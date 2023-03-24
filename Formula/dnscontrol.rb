class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.29.1.tar.gz"
  sha256 "16b7ef9eefe2d09b19297314a5f3118d77367145050d901c06b3c0b65f0daeda"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3577d9b6caceaefad5a74bfe6fb135b841d82e59acd5fb4d009688f80dc529a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3644d6509fe679895b1fc6d5d055f37208efd7fa3ad97941042a561064b1ff12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0e26ac1ebfcfd41675486556778b61c7f385e8bfb59db50e6232f7e60217540"
    sha256 cellar: :any_skip_relocation, ventura:        "9ae433f81a62e20af3b6dd252958e4ea23f179cb8bada7576d31d3257d068e17"
    sha256 cellar: :any_skip_relocation, monterey:       "bbe6e40c8735839f2a1ca4af31d78930762b90ce9715f0676b455ad85b0a4dda"
    sha256 cellar: :any_skip_relocation, big_sur:        "595d072e102b2a11556be7d4133c00a52b060e4008a377e70722863665e1d04b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2e4c5c4c1fe29dd272658ed1bc21874c3c268bafec0093ed0899666070b44c5"
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
