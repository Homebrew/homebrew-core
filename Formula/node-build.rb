class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/v4.9.1.tar.gz"
  sha256 "be3f11748c50b1b0e8e1eac7bde5056d5c60df5114babeb16778d27b710931e8"
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
