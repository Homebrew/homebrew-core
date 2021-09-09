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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "898aa348713c1c7f5955dacb82b0299b00997a49ab209cf5709d02655513a06a"
    sha256 cellar: :any_skip_relocation, big_sur:       "43f3938801a6a2763c5d4966d2b1f4625f0f174265c04ea63e82d04577bf54c9"
    sha256 cellar: :any_skip_relocation, catalina:      "8d4ab0251e7fd808947e2fe616d65b856d28a518724d731d0d8f79d7e25970b8"
    sha256 cellar: :any_skip_relocation, mojave:        "416ab892e88517b4c44ef6f26fcfe832f395c6906a58e13241697697c6a9c91b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48c3eb02b93da5b3dc9cf8a9b62b2cb63af352ceccb7d7e683d777c0b4e90c7d"
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
