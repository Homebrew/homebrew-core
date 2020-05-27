class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.1.1.tar.gz"
  sha256 "5787171c486de01dd1e5f2378d1098e64212c0ee18559aff515bd8c0a06cdcf3"

  bottle do
    cellar :any_skip_relocation
    sha256 "844c4c98fcc4614c70802801324a4e61aaee50ebb34e22293eedc81cea6e4942" => :catalina
    sha256 "a64147f07691bdc6b3fda500838ad1d2ba8540dd66ab8068fbd11b80f161a1c8" => :mojave
    sha256 "8db02587a5f0f3c50dc8ce22b3e2a1e0b7382bfaa5c7d5c55fc12d5d17568bd1" => :high_sierra
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
