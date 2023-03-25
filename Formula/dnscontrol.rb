class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.29.1.tar.gz"
  sha256 "16b7ef9eefe2d09b19297314a5f3118d77367145050d901c06b3c0b65f0daeda"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b482bd537b45e385645b44ccc711f8ee54ea1e26620251d4be62b6f184140ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6fefb81d4c7df8503f12550b955369718766ffe082b4b5406c7753e415056be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4000d204dc9c22b06041789fbcaaa7b740547e97693019bde9c6beaa067321cf"
    sha256 cellar: :any_skip_relocation, ventura:        "3b434be0308fad2b2db00b42fddc4460eaa22963c088b528f96533c75e2cc7c2"
    sha256 cellar: :any_skip_relocation, monterey:       "4ce649effcca96e0f40057f263af1dac96c310529b1c3914fb2d073094e2d38f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f055b40b3cf4986c05f85ff5b29e8f37e32a291ddaa87fc031562c858e1acb66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b1d2a12ba0a252f29f504f998f483c79ac38b3b1f383431ab90c7dedd307470"
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
