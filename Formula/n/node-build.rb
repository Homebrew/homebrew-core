class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.4.59.tar.gz"
  sha256 "3a7b65b44c51e2be0a368e26aa9246b37ae07dcd48d5b3acbc4d3c0e21d515cc"
  license "MIT"
  compatibility_version 1
  head "https://github.com/nodenv/node-build.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "69ed234bb9627e88d4a8b7391ba3c90589b7c022ed72e2c6cc3cb4d2417aa4a2"
  end

  depends_on "autoconf"
  depends_on "openssl@4"
  depends_on "pkgconf"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system bin/"node-build", "--definitions"
  end
end
