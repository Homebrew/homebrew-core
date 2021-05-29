class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/ipinfo-2.0.1.tar.gz"
  sha256 "86a40d5ea784bbecb1ea570cfaaf3a9924f87b52fda1ef2ef978f2ed95422d67"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "aa19540de7e6a5a07401f87df2a3df232c6464171842cc57c7ff0d4f36c9ff27"
    sha256 cellar: :any_skip_relocation, big_sur:       "d9aa10ccd5db7e49054624cd5a48a1a1c8299708c496906302d7d993efa2ba48"
    sha256 cellar: :any_skip_relocation, catalina:      "9bdff53d550c8f26d424ce72a6693a089f55722424fbbf6380be58bf9ed03c77"
    sha256 cellar: :any_skip_relocation, mojave:        "273baa563315200db6e37a434f2fd270b05256c8fa275bed0449d9eb4a5656ec"
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
