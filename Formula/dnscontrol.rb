class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.24.0.tar.gz"
  sha256 "1aff1a1e1dc033e545b296823e4d4d2958c3d450a3eafff20e391767198c41cb"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a4ec381fb14cd3f3322e1457b5e7acd25da87ece28c75b75743ffbde15202ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef04a4ca14ecc550071848da7752d58a28004e9f8d0ccee448f349c77d17af12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "731f20e33dbe6268a0f3a81b76a1b0a4cc2d971a5e990dfcd722cb94680c94f2"
    sha256 cellar: :any_skip_relocation, ventura:        "1d5ca428138546e452a6b23c7dfe15fa7160851f3cfed903a30f2fd1bce6abf4"
    sha256 cellar: :any_skip_relocation, monterey:       "a03bde9e3d05577cec5895af6f3f418dff0050cdb97c34a8ada593957a5e5485"
    sha256 cellar: :any_skip_relocation, big_sur:        "9248a91510b7ff9891bba5e3c87e70027c010518d36bfbd056ad3655e2c66fe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dbc56eca3572bba6924b592007871e752bff89fd9e7d7d740cabf9b3e15aaaf"
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
