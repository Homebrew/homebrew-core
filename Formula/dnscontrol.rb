class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.2.0.tar.gz"
  sha256 "911a31e4a3131f3ecc9c44bc6f1a30aa1259028de504116265bbf516510cd931"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "11902a795449df78e2ce8174379731bdb4de50cc33db13572f4fb2b69d26bc60" => :catalina
    sha256 "824126b2be00c26cab160969986e4087e009770a21f137c30a5a21fec6abfab5" => :mojave
    sha256 "79ba6c6fc6bca016d55960d7746a8b6fd29477eeec4b37d88ae2630d2989f2f2" => :high_sierra
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
