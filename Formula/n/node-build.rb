class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.3.1.tar.gz"
  sha256 "6c0b06e304a3d87692c3d51a49201a76067cd1ad5fb78b053cfefced24d59c2b"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4059b5d57164f86573ad04ff405f1321f10920edd800beb83dc24ba69e7c98ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4059b5d57164f86573ad04ff405f1321f10920edd800beb83dc24ba69e7c98ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4059b5d57164f86573ad04ff405f1321f10920edd800beb83dc24ba69e7c98ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "4059b5d57164f86573ad04ff405f1321f10920edd800beb83dc24ba69e7c98ac"
    sha256 cellar: :any_skip_relocation, ventura:        "4059b5d57164f86573ad04ff405f1321f10920edd800beb83dc24ba69e7c98ac"
    sha256 cellar: :any_skip_relocation, monterey:       "4059b5d57164f86573ad04ff405f1321f10920edd800beb83dc24ba69e7c98ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f47e6e3bd43af8974a7563c0cced4d935321042dcb0eb4bc87506e03c10aa626"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
  depends_on "pkg-config"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/node-build", "--definitions"
  end
end
