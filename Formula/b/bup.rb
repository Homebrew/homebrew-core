class Bup < Formula
  desc "Backup tool"
  homepage "https://bup.github.io/"
  url "https://github.com/bup/bup/archive/refs/tags/0.33.4.tar.gz"
  sha256 "f51284f2cb24aa653288f05aad32d6ec6ebb9546143ed7c588d40ba82f24b79a"
  license all_of: ["BSD-2-Clause", "LGPL-2.0-only"]
  head "https://github.com/bup/bup.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "072a23a0d78a3edbf310c11a4806790f6db210cb46360b68967d7dfba0abc8be"
    sha256 cellar: :any,                 arm64_sonoma:  "1e8bb051d48feb51a4a4e9131c9a57d6bca1b18cd3f991308a51d42a74d0131e"
    sha256 cellar: :any,                 arm64_ventura: "20936d4f42a86c5910976a49237d66de3ad1322849fc6e817c7a61388f7b6fb2"
    sha256 cellar: :any,                 sonoma:        "9a81da2b651bea27265b21ea5acd7f0f51980833d1b84601f99e56ba20bb60ef"
    sha256 cellar: :any,                 ventura:       "968afe49a84bdb342e6017d9a20ac9e0e2fc4c16d0dd442012378b4f54dd4f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76c01543e2d93d089488d0e942e833d7d30889438fe7ed3370ec4044228478c0"
  end

  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build

  depends_on "python@3.13"
  depends_on "readline"

  def python3
    which("python3.13")
  end

  def install
    ENV["BUP_PYTHON_CONFIG"] = "#{python3}-config"

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"bup", "init"
    assert_predicate testpath/".bup", :exist?
  end
end
