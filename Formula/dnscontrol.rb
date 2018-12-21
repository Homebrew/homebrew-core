class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v0.2.8.tar.gz"
  sha256 "87018f5d05f407ab30db782f26d0b42cf80b340de1e695467c193ca9446d6c5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e07fa584fa217a7287ea9064e75a1136d6b934337ad555fe17ed203f62ad000" => :mojave
    sha256 "49263f73ae4af1ca1063c275d730bf8727dd7f9f2b2dce870e59c9868e584c16" => :high_sierra
    sha256 "17e7da48182cae21c5a55afc172d33f8c9662553cc3ff84b48b5a09333fd18da" => :sierra
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
