class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v2.11.tar.gz"
  sha256 "6570391bb58b6188ad613fb0aef23da988c48e6cea2d697c61aaefe149ddc539"

  bottle do
    cellar :any_skip_relocation
    sha256 "8da55ec16df14e808ed85d46f0cff9fda955fcdd0a42976f4311bdc943977ef1" => :catalina
    sha256 "673f2c71423139578588b9efc27758aaafb34734f751921f33edf023e8f0e5cf" => :mojave
    sha256 "5e8070b5d8be878b90657bee6d090b9ceb93b5a8bb14b68490c4a408308db964" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    srcpath = buildpath/"src/github.com/StackExchange/dnscontrol"
    srcpath.install buildpath.children

    cd srcpath do
      system "go", "build", "-o", bin/"dnscontrol"
      prefix.install_metafiles
    end
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
