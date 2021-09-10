class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/v4.9.54.tar.gz"
  sha256 "487dbd49c3b81c0f9f89d22f3ece5046c693cf3eb86bf96f44fe87386eaff1cd"
  license "MIT"
  head "https://github.com/nodenv/node-build.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2db5d603cbf71a3933e3b4c9d061236d73c79f7f2f558135c15b35db6ebef34c"
  end

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
