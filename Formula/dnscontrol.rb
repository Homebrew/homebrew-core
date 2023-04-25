class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.31.2.tar.gz"
  sha256 "304432c804c30042c575893e28a8c7af4222fa4d3159e8c4ff18eef24c5b6a07"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f1d73eaa8e3316867f84065c1f322bff0dbebe0d5082a96013c5d65546f30cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e9c18f67ad5ac265346eeada8cc3c916cff44d2b1ea749515c12bccd02c816b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6595360d6652c604a43662dd90e91c86d98b6d4d4ad4813284ed790b2fdbb93"
    sha256 cellar: :any_skip_relocation, ventura:        "76633c1af07d91c12653ed09ffe471d34ea74c8780ce66a94f568b6357a1e552"
    sha256 cellar: :any_skip_relocation, monterey:       "8578f4078ec5db938f20d5fed62a782497e113c7a2ba336f3783a842f9c69b79"
    sha256 cellar: :any_skip_relocation, big_sur:        "f45e7d5905909ca52cb2ffba0aabcb061bcc8f2cf2973eb3876403c0ddcdd2fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51ee9bea8d19ff1943267ba4e7318e40b709fbb1297c76fde4ac248ef983e5eb"
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
