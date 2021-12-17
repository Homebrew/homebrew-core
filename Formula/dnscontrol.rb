class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.13.1.tar.gz"
  sha256 "62a5c035f5dd043894d6b3c613878e97f876b4cb8d0b8e11923a786459f78694"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23ae51abecdb5194dbab329a3860b7b75202ffa1c505a7fc63c20cfe01369f5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbcc016cee3736c9be5fdd9917366dd7f85a6b52aace2d3c1c4cac2fe4770d8b"
    sha256 cellar: :any_skip_relocation, monterey:       "c31f1204171a219d46aa681791c33a26b1e6ffa89d5fe64abc318102938e556b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f42a09c5427cf4d3c2e8fbc806d081bd2e202620bb4eb25dd71926fd92268e6"
    sha256 cellar: :any_skip_relocation, catalina:       "4638202644af49c5cb01a9953551bb8b96e7066fda7fe74e439cd0a260ac2801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ad544215af2b2fc282e216ae8997473696bf48141fe1f74a3c554d1ad86b8d5"
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
