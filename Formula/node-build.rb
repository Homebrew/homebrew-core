class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/v4.4.5.tar.gz"
  sha256 "c318bb8f3d0e8849021084765eaa4e16863621752fd0e6642dccdbe97dc02a82"
  head "https://github.com/nodenv/node-build.git"

  bottle :unneeded

  depends_on "autoconf"
  depends_on "openssl"
  depends_on "pkg-config"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/node-build", "--definitions"
  end
end
