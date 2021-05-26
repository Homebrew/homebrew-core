class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/ipinfo-2.0.0.tar.gz"
  sha256 "285d73be5fc663cca460298787ff970263baf7c217ffd5ff7bc3bf435d730413"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "136f4062559677cc98b40b1397d18aa07b9082d7b769693c22b3187c689ee236"
    sha256 cellar: :any_skip_relocation, big_sur:       "8b1f6ae126718d34b543b5a1d249fe474dde0f93dee281e405608089de48f946"
    sha256 cellar: :any_skip_relocation, catalina:      "215f6613824d7d14ff932d2aa835be7858fe62c046dfe2e22d3bf170f75c0f1c"
    sha256 cellar: :any_skip_relocation, mojave:        "d7b7be653ec858cc681d5383965e2e0bee4ee12c1b343aef1104ad1175722fe0"
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
