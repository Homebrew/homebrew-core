class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/ipinfo-2.8.1.tar.gz"
  sha256 "efc690a7a532db51395de9b744651e09c9db0fe8d7d8f1285409cddb476620d3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90d8433c756a9647b82934de232d0206c84fae2e349e6ee9833b4b94a0ca2158"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e42125fe8b521947f7db9bcd075653d0e3b1467f758db9ef224e41e504f9cc1"
    sha256 cellar: :any_skip_relocation, monterey:       "5c9952a5ca493a208ee397014ab3fedf69b8c4c7f8a007646b1bcefc2d8d9d78"
    sha256 cellar: :any_skip_relocation, big_sur:        "99bc7ff9277cf348b434ef3ce1986eed3198c072f05b0d4cffc64f7eb9ea6bf7"
    sha256 cellar: :any_skip_relocation, catalina:       "18ec21b78070125dea73790faa93a514cf7d1bae5af264462479142a9a83e0cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88574a542fa8697f06e1e33459876c95faed96885d63fc5f5c8107024c5c6164"
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
