class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v7.3.1.tar.gz"
  sha256 "92754b32607571e4a8d610ac6df18f43bbe7380927d79e1ef640c516eca88458"
  license "MIT"
  head "https://github.com/tj/n.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b6de450720562933bb5c62291dd2287693152ab78848353f31b01ed3fc7b7ab6"
    sha256 cellar: :any_skip_relocation, big_sur:       "90b5086b775be4ff3b4be4a5789c301f8899d1e151f2a0875a21daa4937a67d2"
    sha256 cellar: :any_skip_relocation, catalina:      "90b5086b775be4ff3b4be4a5789c301f8899d1e151f2a0875a21daa4937a67d2"
    sha256 cellar: :any_skip_relocation, mojave:        "90b5086b775be4ff3b4be4a5789c301f8899d1e151f2a0875a21daa4937a67d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6de450720562933bb5c62291dd2287693152ab78848353f31b01ed3fc7b7ab6"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
