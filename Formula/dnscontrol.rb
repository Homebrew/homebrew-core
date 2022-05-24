class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.16.0.tar.gz"
  sha256 "21a5bd9cb096ff65d298a6db27892ce5ea5150a83328f089f9c86638b42a1393"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae27ffce26e354e7ae361e024b8bd7aab04dddc82cc8883d845178369fe86755"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "425d991c50658802fd71bb160cb93385c050e66f4f77e4a07e265e6bceeb05dd"
    sha256 cellar: :any_skip_relocation, monterey:       "473ca91c2711b7c7794c1801a65560f66bc2e39e3cf847d4b27d03df07215d2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "787160a84494425d5a6c3464b575ab30f0293a7fa731fbeed490410bf92a015e"
    sha256 cellar: :any_skip_relocation, catalina:       "481e22232d02b8b0a778b066f0d45badc2155fcb42e7681bc819df41cef9731c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4af7ef320c8f5b0a2d1f2d1a85d1d1d8ed461ca2b5c03ba3031246cb2a8d8ab5"
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
