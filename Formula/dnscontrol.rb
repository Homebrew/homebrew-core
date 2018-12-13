class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v0.2.7.tar.gz"
  sha256 "2889c6bec5c4b77a21bda82a1a3760ad64667f8a30ed009b4750f605c9827598"

  bottle do
    cellar :any_skip_relocation
    sha256 "f73c7d1bfb445b7cb48471889130e59403c9d65de23f6856b0bf996b598e0a7a" => :mojave
    sha256 "6b6f2ab020128b43a82a51ce7358756657dd7440b0b42daa30be63520501f5e8" => :high_sierra
    sha256 "b43bbcea38da57e4007d4db52ab62b390d680f0979b9c9163fe32cf768d44a8a" => :sierra
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
