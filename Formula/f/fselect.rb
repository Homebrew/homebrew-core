class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://fselect.rocks"
  url "https://github.com/jhspetersson/fselect/archive/refs/tags/0.10.1.tar.gz"
  sha256 "20425a3ab36fd46b24bb280a3c13187e0b33ab2e68734d8f51b07710af25581f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d4c3e017c07dc262bae5d8118fd93ea8573eeb0eb2cb01e613c131d750681d27"
    sha256 cellar: :any, arm64_sequoia: "36fab41921ba4005ca8c064354a22f7dbf899155b6441c3251ef76a034a09fec"
    sha256 cellar: :any, arm64_sonoma:  "f75cfbd80e8acbd46b710267cbabde59792f3e729ad8d01e9aebd8a1eef78159"
    sha256 cellar: :any, sonoma:        "3b134d16f9b42c3399ddcfa0b5efd2dc468176608ebcb0fd07bed2a9ecfd6f35"
    sha256 cellar: :any, arm64_linux:   "82e48da21d44dbe91001e1ed5c4673a3076214a1ac1d88d691e73d07426980a8"
    sha256 cellar: :any, x86_64_linux:  "fa8ecc43eeea3bcce514a66cbc953ad69f559ecf7d990b44ce45e80a6108265a"
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
