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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "beec1217ecd3a92b1a45beebaa84e6ad638ae9760189d033be9ba3eacfbe27f6"
    sha256 cellar: :any_skip_relocation, big_sur:       "e8dd7b402cb6da72444a2af2f40cf26922324c563ef9393e7cfdb95e06a1cae5"
    sha256 cellar: :any_skip_relocation, catalina:      "476c460ff0328731ee72e275264a6fcfb6d3bab46434b04427a9c3ac9e8082c2"
    sha256 cellar: :any_skip_relocation, mojave:        "2bdcd2c5bac3a501873580abb0472abc607a85bf103adceedbb134d69f40e51d"
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
