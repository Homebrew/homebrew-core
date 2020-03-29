class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.0.0.tar.gz"
  sha256 "6bb718c787aeb6b048644e4b437fcbe3a805d9b844cd71e21cd29c82aaba42d7"

  bottle do
    cellar :any_skip_relocation
    sha256 "31659d8d24a42a4198cee85996f088371a690a117a7180f4fb66b9a91a95368e" => :catalina
    sha256 "1961f8e932a9c45ce3d8875ec79a748f771abda2d837e5cf27ffc82d2c957fe0" => :mojave
    sha256 "95eefb8221d2010d797b439c8bce6de4f72a1d0dab7a83bee9f22384e63f54ce" => :high_sierra
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
