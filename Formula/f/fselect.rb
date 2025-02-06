class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/refs/tags/0.8.9.tar.gz"
  sha256 "08a903e2bd7d68dff004a6552dc5823989c74ce20a96416601ce7002f6b51a7b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c1785ec66f4e55b795503170aaf43b4ab897b2da4852acc072f8eedd0c3cc7f3"
    sha256 cellar: :any,                 arm64_sonoma:  "726d35a261fe7fbe30c4c4f2ddd145d23ff33075fa646e322b1f9d41daaf731f"
    sha256 cellar: :any,                 arm64_ventura: "43bba5700b6a79fbef7f60189e63357cc3baa01e52d0ae56d4a5d4c531a11fdc"
    sha256 cellar: :any,                 sonoma:        "d5e29d73d836e83477d197bb6154435c058c50c672ba46b0b113620609109063"
    sha256 cellar: :any,                 ventura:       "b087b27e909dc500699ac7e775d3d0b8971ab27670024bcb443a2358b8525c68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "121d50a814277f56cb8b684746e81ac02f79cbd14efdc8259dbf85749ec9728b"
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
