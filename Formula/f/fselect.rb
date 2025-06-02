class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/refs/tags/0.8.12.tar.gz"
  sha256 "d5ef50dfc911c4e0a8e85d9473f9b69e812b2c0c3499f83bd1a36258a87889e8"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b0db40bf7d1225d8117f272bb2dceace6326abd95f2f6eb045660b2e17d1a897"
    sha256 cellar: :any,                 arm64_sonoma:  "86014d39b4d9dd41967c16b7a41538940d70ff660b00c5b650474ee55ef9e3bc"
    sha256 cellar: :any,                 arm64_ventura: "d7eae6d1b663ccdea1e1c394c82091a0a1eb17977544a440732bda6a7bb5e52e"
    sha256 cellar: :any,                 sonoma:        "21ebce511169b8e96020600fe580e60660cc54017c6b96c5b5253b4a2c60d38c"
    sha256 cellar: :any,                 ventura:       "8a025baef60b5d46d96cc97f6ffbf20c018fdca65dc9999a3263de31f16db9c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80e1376b75027b364458fbaa492e78b6e91c2002c754295b3a69d46c5ad6bffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ad0338cfa975c35ced7e76c837e86e6f257e028a33eced45726dacf25444915"
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
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
    ]
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"fselect", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
