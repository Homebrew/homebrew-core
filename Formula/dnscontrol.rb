class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.27.0.tar.gz"
  sha256 "e9e742f1a984c13d6e64f5f041f8ad21ed1f6881a7081b3b43efd38329c254a1"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5d57d6454113b9c0d1331dcef0d91323ed51578f570b54c675aef95c355f2d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58bc2aa00f02b0d6a6555b55901ecc0dd255dee7244db5b55886656916451f5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c0ec2ebb9b9e5c4af3d1f0a420511a06d16369dd2beafb85379d78523e32e94"
    sha256 cellar: :any_skip_relocation, ventura:        "669648e575af5947a9704e270fdb303f88b023b21262dbc0538f8a6716d3e0d4"
    sha256 cellar: :any_skip_relocation, monterey:       "775a253e0d39509895a45c27c3d643ca9494488db2d7283e4086fa9f963ef324"
    sha256 cellar: :any_skip_relocation, big_sur:        "56a74f2366011219b971e939aa17e63350b8d317ca008bab33637fa72676c46f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf1c828bab681bd8ab8ecd485d1981384336132e51bd243750f03af52ed242a3"
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
