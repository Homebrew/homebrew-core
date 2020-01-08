class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/v4.7.0.tar.gz"
  sha256 "b6c80c553ab56018a2fb0fade0a848e4051b9003f23c852fec85e524dfa2b776"
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
