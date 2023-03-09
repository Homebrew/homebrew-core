class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.27.2.tar.gz"
  sha256 "3cc2cda0747046f959e518717d6d37336b617902bafc360e2cc3492503af9d3e"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77640408e9442a8c8b5451cf37d6b8d7c30f5468a96dbbe5fd39dae7695447c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7a5967aef349f21bc3f78b73e65bbc4b969024b9e3f2c9d88e6015ec2148508"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "194bc65e053c72a24813fdf8cf6482ca18bc89c87910c7aea299cf5b938f09c5"
    sha256 cellar: :any_skip_relocation, ventura:        "b8d1de35fc12097d17969e5e3bf0e413423d346b9c60acab0bf5e301918692cf"
    sha256 cellar: :any_skip_relocation, monterey:       "1398473db74276d09e2da1dd424c5f5d073db94bd0fa33ca3edc197a588ef51c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b410c9f3bad7674a406bf3111c6b21def5355dfb47d7e120cb02d099aebba01c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b84ab55cb7dcbdcac2c70e7554377911a216f328df3ec40a4af8805f01af209b"
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
