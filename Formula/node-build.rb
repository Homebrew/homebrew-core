class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/v3.0.12.tar.gz"
  sha256 "25c0b7bb572d7a48fa81206e0fdbd3b0f1b00f3ea4eaa495104a4935dfd3507b"
  head "https://github.com/nodenv/node-build.git"

  bottle :unneeded

  depends_on "autoconf" => :recommended
  depends_on "pkg-config" => :recommended
  depends_on "openssl" => :recommended

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/node-build", "--definitions"
  end
end
