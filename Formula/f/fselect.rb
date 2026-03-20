class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/refs/tags/0.9.3.tar.gz"
  sha256 "ea824bd6e57926e243c98ed2fa73bf3eb412a3bd837c388abb1451d727dc46f2"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6012072ed385ad316f39de794afb461d421aaaa617d98d2d08e2c08a885ba799"
    sha256 cellar: :any,                 arm64_sequoia: "dc51a0103f33d77e638b2075f26cc83ca0d4443e482b8b9f0c9992503a60cc34"
    sha256 cellar: :any,                 arm64_sonoma:  "d76ec08ec382c41513c7a999d96e43de5c08c1f955bcf1d6020bce7028570dee"
    sha256 cellar: :any,                 sonoma:        "fa3b635fad316dea45f716fd0617d71ccc804f8efcc9ddfd242ad93d378d0e53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0869a3bacc37714a896575c476c16697017b81320b388987bc4e96c779a784d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d81f0ad844aa4d91a6400507bf974c7e034f73fb97fc2571a288c29a27173b6d"
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
