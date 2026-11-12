class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.4.63.tar.gz"
  sha256 "a8569f0b6283017ac712e1b18f97d71e5d78120afd6bdd72a817aaa95a74a7b4"
  license "MIT"
  compatibility_version 1
  head "https://github.com/nodenv/node-build.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8c3c75039381c3c81023e17216742d676646424fcf3c41652e51a1f37e6bcc64"
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
