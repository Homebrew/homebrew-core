class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://fselect.rocks"
  url "https://github.com/jhspetersson/fselect/archive/refs/tags/0.10.3.tar.gz"
  sha256 "e2dc2d40c58c273a6e9efece80ad14dc05f07ad01bbafd0fba5da3ebd73464e1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "99cec9b7bba4d90fca104cf8949826a97849d041f2f052007f5fcedf32a1d6c5"
    sha256 cellar: :any, arm64_sequoia: "42f58f785525bb87984c994713ffa21a44a4ceabfeb812c6548a8d1570bad3fe"
    sha256 cellar: :any, arm64_sonoma:  "5c79c29b248651ff890eb213928065f46d0b36359bdbfe1d8fa41bbf79bdb75b"
    sha256 cellar: :any, arm64_linux:   "614ab046a0b92ee63de2494eb6ab0cbbe8d8ffabedb77e8666325938dcd90b75"
    sha256 cellar: :any, x86_64_linux:  "1b63add6068e7da53581b051d2c290c7a187ae91a7d6c7ea1c675964587a5f90"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "libgit2"

  uses_from_macos "bzip2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "utils/linkage"

    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp

    linked_libraries = [
      formula_opt_lib("libgit2")/shared_library("libgit2"),
    ]
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"fselect", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
