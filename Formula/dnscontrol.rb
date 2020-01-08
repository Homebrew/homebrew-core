class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v2.9.tar.gz"
  sha256 "6c3e739b56c64e2e41a0cb23f4debc3db6889aca0a78016c730ef8d1e42709e8"

  bottle do
    cellar :any_skip_relocation
    sha256 "01e6fcbd2b3447ba107ec54f3b716c12bf79b8e183c0a74eb40a0e2717673fc9" => :catalina
    sha256 "98e5230bf0b1ea268e30c79567231d9fdeb9ead2afab1d66d3a6a225dbaca365" => :mojave
    sha256 "fd72608a2ba25ded69086be111de8712ca2815252bc1706a4371b1c37e70cd54" => :high_sierra
    sha256 "0895b13b50fec182649a62617a29b9084d05aa38f8f6013b9847a76a174b4b48" => :sierra
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
