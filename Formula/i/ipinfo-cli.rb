class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/ipinfo-3.1.0.tar.gz"
  sha256 "ec7108a8e17b845dc7b5ec2cfce888c0ef9ea9bbde28ce67fbc37e7ea450c8eb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2680a6f06685754cdbd794ccb8442369f0397d27930e68d182bdcf2fb45ad106"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70c4ca4fe533acaf1439eafbfa68e5ba8222dbb728b7047087ac5c82209e505d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "532d76ea5e43ee2ba178be5c221a4c571142a4ecb1dd4f6d3ab8c584fa5c44eb"
    sha256 cellar: :any_skip_relocation, ventura:        "b8a889f482fe5d05efaca6fda2178df13d0096324b3b64b00995ebec51f6d85a"
    sha256 cellar: :any_skip_relocation, monterey:       "db802659f8d632b28f17365acf2140164fe0a7448418d3e2fd1f52924a0245d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa35d504f7ef51732bcb8fef492f8efb0eac2833bd24202837f6bda687da5f9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60596a7d87d028ae4b63a6efb92a1c42e3999ae336a00e9705978e18b89aa72d"
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
