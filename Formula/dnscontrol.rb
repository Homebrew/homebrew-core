class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.20.0.tar.gz"
  sha256 "6aa164f2b3f8a07c0460bb0f75517b202c26d3c17d05a7f0a6073cfdaa0eba0c"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa4457b15be33a58fc9f9ac38042663c9873b97913ca4df7cd787e2dc8be21a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9413eb133bd258f50f57203c24c24ecde3acb2c763a1c7d63d88140ffb0db495"
    sha256 cellar: :any_skip_relocation, monterey:       "f64a906d88c3a74c8c63928ca4ea4b7fd3f4c5accff2bb08b47345e453be0e74"
    sha256 cellar: :any_skip_relocation, big_sur:        "de5d75690694917383315d9b9db7b344528dee183e11517129b94e6cdc224f96"
    sha256 cellar: :any_skip_relocation, catalina:       "27f82d18854a56def811b8ded702a3227d1297beefcb1a22cf86a9016980870a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b13efeee639f0dea81ae505a7b9c8aacba78072d6b9e88bcfda8eb39ea0c3cd5"
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
