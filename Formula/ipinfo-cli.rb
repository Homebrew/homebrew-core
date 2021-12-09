class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/ipinfo-2.7.0.tar.gz"
  sha256 "a111d1d9180e65ed52eefce59b63b851420df9548b8aaba8742e0a30136c3219"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d79a2c9f00af05abcbee89db9fa1f13e46be53a1e90710f145ac24e288a5440"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77131e6da8366bf4bb161874b80de3843c32253af941d1ee6983b7b44cca4a57"
    sha256 cellar: :any_skip_relocation, monterey:       "b608eff4c8ab515ebac8feb5ce20a69db3911d4413c4eb0c0da49d75e6f2c2cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c24fd6e5937a2f875c8155938a4eeb4fb9e7cb61509209b247d0b40cb799231"
    sha256 cellar: :any_skip_relocation, catalina:       "c45b3471529b29a2d3ed38d2d34cf959e8d5d5b9e1a96792665fbf5e50fddba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a51359d572615635ea8c37d4286f380be64558df77ad6fc955e1bc400c0feec7"
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
