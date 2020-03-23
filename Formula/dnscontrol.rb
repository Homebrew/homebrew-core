class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.0.0.tar.gz"
  sha256 "6bb718c787aeb6b048644e4b437fcbe3a805d9b844cd71e21cd29c82aaba42d7"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d5b2d3f3a58c4fa17a5d05d900cf964f55d79fa33154feb6ea31748073359b8" => :catalina
    sha256 "2bdcefeda90832c5a1726f0f9002692d2aa609d70e2b0ce9dc1cdda6423794ff" => :mojave
    sha256 "00f3cd3611e52eadea634d3300c41f5f529dcbc3ae4127a96c5419e5dc9da956" => :high_sierra
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
