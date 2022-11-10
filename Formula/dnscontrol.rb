class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.22.1.tar.gz"
  sha256 "bbb8de871792b8c16ad5c831dc5b0d0165d7358a13eb31ffff521d3c1c749f1e"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16fb413affcef359d25dcf338bba2f20b1ba3f5f125ad21a0e85e53551a392ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cc2324f9c5a1ad1a7a49346e86d499e01feb4df1db04b8ff8d7e3d243225630"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb46dade714b883a429e9bf17b52290f7b00354a1c74ef0d6aeababa2c720de9"
    sha256 cellar: :any_skip_relocation, monterey:       "23b0aba3d36ae1457592dec6337d53062e67f449b74b0621168098ede668320f"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfc5aa69b3342a066c0d11693070b613b2499c13f6a35355e83afa2f12c767d8"
    sha256 cellar: :any_skip_relocation, catalina:       "4f3a9acd8eedbc57dd80050963042961bcfa59b716e6cdecaa393595d484a619"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28e81a3d46147ec725ef7e43fdd713ba988c9e518e4e11ab0940965cf45927fd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
