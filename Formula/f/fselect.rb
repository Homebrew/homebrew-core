class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/refs/tags/0.8.11.tar.gz"
  sha256 "aafd7d6463a1d8d699a9d3f80295b66aee1b6dc3748c9409c7b76f5fef9a180c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8753a03ee239694b36731d3de0afa40691f6b92afdc43de1dc7d02a323eb645d"
    sha256 cellar: :any,                 arm64_sonoma:  "20b9eedcec8726d400c54700008d614e582980c16ed0db76e106fe78dc7d4855"
    sha256 cellar: :any,                 arm64_ventura: "7480a6afe203eebb01ca385cba2fe35e8888d6bd506ceeac39b3a3e07ddce22d"
    sha256 cellar: :any,                 sonoma:        "31aa80e99167c000fa8bd996ca9aa7ae418a8bfa7433a779dfc07ea91b36bac0"
    sha256 cellar: :any,                 ventura:       "e836162794da0366ddb4ac37cebcbe3cc5a5c0e6698a35927082ed300bf1569d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "893747899170c0a9d72fb1c928d279172f4ed19ea591d48457c3c4508963baf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb0764eec636d432e88c5abd2b7e21ef4430df6d7e26234605b42bcd84df0f3a"
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
