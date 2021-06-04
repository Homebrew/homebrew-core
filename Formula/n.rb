class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v7.2.2.tar.gz"
  sha256 "9654440b0e7169cf3be5897a563258116b21ec6e7e7e266acc56979d3ebec6a2"
  license "MIT"
  head "https://github.com/tj/n.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8f377703e852c68fd063f5f15ed7606ded6f3006ccd8b11f6cc06667c5d52fa1"
    sha256 cellar: :any_skip_relocation, big_sur:       "1a0c2427ac36e4f4f6175380e2545a79de41031bc54021d8061f09d5cf6dd67b"
    sha256 cellar: :any_skip_relocation, catalina:      "1a0c2427ac36e4f4f6175380e2545a79de41031bc54021d8061f09d5cf6dd67b"
    sha256 cellar: :any_skip_relocation, mojave:        "1a0c2427ac36e4f4f6175380e2545a79de41031bc54021d8061f09d5cf6dd67b"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
