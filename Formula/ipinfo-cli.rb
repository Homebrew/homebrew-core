class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/ipinfo-2.0.1.tar.gz"
  sha256 "86a40d5ea784bbecb1ea570cfaaf3a9924f87b52fda1ef2ef978f2ed95422d67"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5ef6ac74514f04d4f0d8750f976350c34f6dcd4244b5ef1c255682db45ec3756"
    sha256 cellar: :any_skip_relocation, big_sur:       "c54f63386eae59b5e71138df8a5d11671076056633899d8b32dea27e73aeaf29"
    sha256 cellar: :any_skip_relocation, catalina:      "880e7f020a5868018be01efc6f38899e1bebeda1cccdf7a3e1382ebbc2f00340"
    sha256 cellar: :any_skip_relocation, mojave:        "0161fdb7268a3a6e5d0a81360708378bfb32d742ac239125bd9a51f74110711f"
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
