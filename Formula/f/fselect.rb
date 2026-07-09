class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://fselect.rocks"
  url "https://github.com/jhspetersson/fselect/archive/refs/tags/0.10.2.tar.gz"
  sha256 "3a51225c41ff0fa460abdbf30cb7434769454cbcba8d717ad24a5c8fa005485f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "57d3f87a0ee032c66d56dabf0bdbdf7e9cda6832c465fadce407d9f5763f79bc"
    sha256 cellar: :any, arm64_sequoia: "0561f52ae184df59f48422ff1b4cb2e4f88eb7c624d6f0d26563a77ccac352a5"
    sha256 cellar: :any, arm64_sonoma:  "080e0c9eb47d1a2b6b2d82534a2ed1f2ca5eca2c7d0f2f77213e9e7f6ad14acb"
    sha256 cellar: :any, sonoma:        "86dd9fd4fcb221b18061b6103c5acb730ca5e817edb10974e49544b2ccbc1003"
    sha256 cellar: :any, arm64_linux:   "955cdab05fc9e960020abbc7c376dbd34d5c4f29ffaf5bc7cf376617a3eb216d"
    sha256 cellar: :any, x86_64_linux:  "f7c021a874ba0ec1cdf5cf9dc5daa1cfff815d70ddbaf3bdf0ee12e1383853dc"
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
