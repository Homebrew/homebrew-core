class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v9.0.0.tar.gz"
  sha256 "37a987230d1ed0392a83f9c02c1e535a524977c00c64a4adb771ab60237be1c6"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30bf1748f3565b2dcb59d73091cb6ee1eab171703c481ab8bf91774183966dcc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30bf1748f3565b2dcb59d73091cb6ee1eab171703c481ab8bf91774183966dcc"
    sha256 cellar: :any_skip_relocation, monterey:       "22fc6ee54f7100c38558c8bbc044a6e5709088ef9ea9c6085265f6eda61d400b"
    sha256 cellar: :any_skip_relocation, big_sur:        "22fc6ee54f7100c38558c8bbc044a6e5709088ef9ea9c6085265f6eda61d400b"
    sha256 cellar: :any_skip_relocation, catalina:       "22fc6ee54f7100c38558c8bbc044a6e5709088ef9ea9c6085265f6eda61d400b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30bf1748f3565b2dcb59d73091cb6ee1eab171703c481ab8bf91774183966dcc"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
