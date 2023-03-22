class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.29.0.tar.gz"
  sha256 "990652dd4fea9e9458bb390584eb3f8cbbd9dcf580963694b1a618de26b9ef0e"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b73ffc14bb90134172d6f35d39b10fd38f0c978125c26c17a52e6ff49a0d907"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6e7d691fd20ac0d251c2d7d8ea1772b1c5d48ab6588b9337955068c240598b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "703735d2fdb435ac2ab94b2e7eeea7df76c8df4796a80b604a6fb2494d7243d1"
    sha256 cellar: :any_skip_relocation, ventura:        "9fad8f21f2c87884195277ff37efd2c46d821454a4aebbcfa899bc6cd90e8d38"
    sha256 cellar: :any_skip_relocation, monterey:       "e1865b50b33a9029428232b061f37b00d40bc34caffc1a5abcd6f18c5bfeb9b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf45083bbb8a84868d69f984e4b715b42c5b499c619e101bceb57db8beffc099"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4d26233551d832c1d4c2e4e15ce07803efe5593a862286d8c162784e5e638b6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"dnsconfig.js").write <<~EOS
      var namecom = NewRegistrar("name.com", "NAMEDOTCOM");
      var r53 = NewDnsProvider("r53", "ROUTE53")

      D("example.com", namecom, DnsProvider(r53),
        A("@", "1.2.3.4"),
        CNAME("www","@"),
        MX("@",5,"mail.myserver.com."),
        A("test", "5.6.7.8")
      )
    EOS

    output = shell_output("#{bin}/dnscontrol check #{testpath}/dnsconfig.js 2>&1").strip
    assert_equal "No errors.", output
  end
end
