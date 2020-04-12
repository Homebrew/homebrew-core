class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/v4.8.1.tar.gz"
  sha256 "86f52e1fc51eeb54dd94d288a2778a6fbe1f102a1a64a2dc3ea4973f91ddc587"
  head "https://github.com/nodenv/node-build.git"

  bottle :unneeded

  depends_on "autoconf"
  depends_on "openssl@1.1"
  depends_on "pkg-config"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/node-build", "--definitions"
  end
end
