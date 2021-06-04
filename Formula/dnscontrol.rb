class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.9.0.tar.gz"
  sha256 "439fcdf683c4660930986eaf387c85612111a8c40d15d860f1f6706e44cf95fc"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f97bce34833e31eff42e94301a7412052c6b9f965b410320a207ef58a09109ed"
    sha256 cellar: :any_skip_relocation, big_sur:       "dc113a15d6cb60307fc1e5c181b47cccbcf664d26e90bf3d9c4d2d4d616575a8"
    sha256 cellar: :any_skip_relocation, catalina:      "7292ecff37f7ad67a091a9c6e2ca58eebd212e44ae73261b803f0f77b6f60f30"
    sha256 cellar: :any_skip_relocation, mojave:        "13c1fb3a2ff2df3fd8a24e14e06430b9d8c1c27502c88b5ef9ceac0d9dbbeba9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
    prefix.install_metafiles
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
