class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/ipinfo-2.6.1.tar.gz"
  sha256 "58f856b63fdf1c03c83514e7479c8b5fb301c3706435f541aaf031ed9be47a53"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5aaf1fbe1b39b0e3ba5e7a07c90de12933f4550721f2a0892088fb5c94456470"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ba610ff4624d9a091329b01a26727c409daa392aac7b2bbef5633d43a355784"
    sha256 cellar: :any_skip_relocation, monterey:       "ccb4c0f9bf19f759f97470aa6fc8685c19f4022905e7eb09a74c1cbc4ea8f4d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "e586c8e69fe3ebb6f83b5e9116259c3f67faeb12c7d2d4871c8e30ec505e0e94"
    sha256 cellar: :any_skip_relocation, catalina:       "80ba3018deb8fc08b1f71cfee760ccd3b330af89b3bbf10fc1830ba5fade938b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "068bb00cb6da8b819ba11aaf46054cec1d3666e1b119268e2159b00d6ef714ef"
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
