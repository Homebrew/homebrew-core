class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/ipinfo-2.2.0.tar.gz"
  sha256 "14ff13cd52d1344c7b683de19eb8cbaa53852d7c20d11dfffc0dd28b66b4cd35"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "72edbc4141b056d325e1fb22ea7dd294fee7598a4e1728c87da000388db700d2"
    sha256 cellar: :any_skip_relocation, big_sur:       "b07a99156cc74d938635140d298e0752e9e8572b24f1a8faaf5909f04bb2d696"
    sha256 cellar: :any_skip_relocation, catalina:      "e3aa4bfc01d7d193c315b0c73faaef3498e04bf886856729e95204d5a6535f9c"
    sha256 cellar: :any_skip_relocation, mojave:        "f8c44267de04947968db348deb8ba79b0d0286484f41a571008d9526ab9e49cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb89e1ea86ea6207500ce5bf4374db51174cf8833883a468d406db940a2c5930"
  end

  depends_on "go" => :build

  conflicts_with "ipinfo", because: "ipinfo and ipinfo-cli install the same binaries"

  def install
    system "./ipinfo/build.sh"
    bin.install "build/ipinfo"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/ipinfo version").chomp
    assert_equal "1.1.1.0\n1.1.1.1\n1.1.1.2\n1.1.1.3\n", `#{bin}/ipinfo prips 1.1.1.1/30`
  end
end
