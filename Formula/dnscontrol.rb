class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.12.0.tar.gz"
  sha256 "2927696096e4b58ef21427fdbecc8aed99e4bfe19a03f63e25bec067734d0c5b"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c92f0076429b5fea9878b86bef4e337fdb762016e41bd59b1832a01893f34ed6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ab5d25f2efb3be5eb8a0048dd55561f7433d8a46aeb1aa7619b80eb58f2e8d6"
    sha256 cellar: :any_skip_relocation, monterey:       "073d7c106085d085df4e2fa18671012191226642885ed6bfe90a507ab88289ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7bec68821ca3a9387aff4cfd8e87ccdb18c89f171da2a5aea51e0aeba26715d"
    sha256 cellar: :any_skip_relocation, catalina:       "cf7f2cdaf988b0ae9601f3b05a3dc14d5ce03f398b0a02839488e664508e7be6"
    sha256 cellar: :any_skip_relocation, mojave:         "c0de2e718b6850ae391642f8a271a0b5105e447deee72ddc95915541930d775e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63cf1329d922e2c5265c23bbb5e30b9ded6913e248fe328de420aca6dd0b1d8a"
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
