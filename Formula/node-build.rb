class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/v4.8.3.tar.gz"
  sha256 "8def962d809d2c1772dbd3e5deca55fecfcf614e8538e395f7564e7e18fa27f5"
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
