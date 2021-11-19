class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/ipinfo-2.6.0.tar.gz"
  sha256 "1230052f9fa953190c0166c54fa223c778ace69863e216c5c6b69d6aa0495009"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48afe956d9772bbbcb311170a821737475f621c07ff09cfd21796aaca6fc23ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a28191796d1fc2aabde393f80f99501216a362efda2b9e0cd6a633be039a9b25"
    sha256 cellar: :any_skip_relocation, monterey:       "2685ac3aad72eb506060caa0b4496abdfdc62fdc0807efccd5e810dcb275d34c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a430fb6a22a36f7d987990834c585103d22a0486644eea6e7b9a1d0fc5a105dc"
    sha256 cellar: :any_skip_relocation, catalina:       "4729faf85598ee782b2cfba63e94aa1b63366da23c5cf57f00dd5c2258daadfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea54907f5061484ba073bc19b3584401bafeecaa3e1dda2d0e38922711ca5e53"
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
