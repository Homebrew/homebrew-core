class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/ipinfo-1.1.4.tar.gz"
  sha256 "fa1b055dd4cca4a5a57374d9cc1250eadba2f17871d38b5b71914b379a9e84ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "10e06e6df09221fcdf459129235e93974a85aa2ad693396ea3b0aa164b38ad6b"
    sha256 cellar: :any_skip_relocation, big_sur:       "75241fdb8a8c1c57008b8e800d85e12b776daa1aa6bb105bdcc3797350a4ccea"
    sha256 cellar: :any_skip_relocation, catalina:      "c36bf401bd83dc3edf3f50fca0cae62de2df9e18a37472e811a6da5896b67c73"
    sha256 cellar: :any_skip_relocation, mojave:        "08c27383a68d0ce8babd740aba0b9826c27766610fe395f07ccea77afdadcf1e"
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
