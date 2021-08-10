class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v7.3.1.tar.gz"
  sha256 "92754b32607571e4a8d610ac6df18f43bbe7380927d79e1ef640c516eca88458"
  license "MIT"
  head "https://github.com/tj/n.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ff4148c324c6bba661668a8506f0cfa189d3ce2f62cab6ad548e5bf686af72b7"
    sha256 cellar: :any_skip_relocation, big_sur:       "c93276c259296d2649d69ae8fc522fc7343512ec8f069ac1ff93154b2e7d9c2a"
    sha256 cellar: :any_skip_relocation, catalina:      "c93276c259296d2649d69ae8fc522fc7343512ec8f069ac1ff93154b2e7d9c2a"
    sha256 cellar: :any_skip_relocation, mojave:        "c93276c259296d2649d69ae8fc522fc7343512ec8f069ac1ff93154b2e7d9c2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff4148c324c6bba661668a8506f0cfa189d3ce2f62cab6ad548e5bf686af72b7"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
