class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.16.2.tar.gz"
  sha256 "c2c923bde3d6bad1790664dcd72fff6ca9f135656b5e19f862d3ad706a4b54ff"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7bcae0885fa92add59382265b11a1725c3d11036963f2fe14c9431ef47ef1a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b286716fe505e855bc8591d688dac2823e3687871058a1f24b48f98af4cd4954"
    sha256 cellar: :any_skip_relocation, monterey:       "815b3a66275eb970c8b3a2d4bd673dd2f7fcdf691c5a4d21b0ec4336cf837519"
    sha256 cellar: :any_skip_relocation, big_sur:        "b49f26a74363b7f67969ee5cd387b11505eef89e7976d96df4b152fbdba74a08"
    sha256 cellar: :any_skip_relocation, catalina:       "16b36301e51163f4cc5b0b5ff5ba1fb751db8c41c086f5460c61d10b137a9fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eccac005ce1eba68ee569b451547a264d641b97c45800ff9ebcfce028a68c111"
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
