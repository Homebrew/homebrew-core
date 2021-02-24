class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.7.0.tar.gz"
  sha256 "f285c71ae4bcaef6283c08fdf53dcd08bab486e134a7c607957df6b70bc551dc"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "02ea4c3764cb5e89510184ed3c84af08c9067bf5bd0e374d42312bbead5c636a"
    sha256 cellar: :any_skip_relocation, big_sur:       "b51c879b8f4bca81f2781b90f7116bd343f7b4f1fede167022aadef6ab5e4f7e"
    sha256 cellar: :any_skip_relocation, catalina:      "e8fb9bf93856177fdae6eb81ac23f2dc486fbdfb3e4d84d8082fcaf1f50ae8c1"
    sha256 cellar: :any_skip_relocation, mojave:        "a27998dac7906c85382296a671f99a8dfe5cd1aa58c58798047a3ec2718ff7f3"
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
