class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.14.0.tar.gz"
  sha256 "d8a35ed30edba837659b3ca1177e8f14d0f00fe14cb832b61e691dddab3ac6a0"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e871455e6eaff3b4d0d8af3038e06ab090b71e72ec6e590f558f1f73a814564"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f04c89c0bf7437df39331343c04b257211199121e089e3500cd3ceedda1600a"
    sha256 cellar: :any_skip_relocation, monterey:       "cb05ddcef24c41effa5aaae45a675075508cf6e32572804e335f2792ac953cb3"
    sha256 cellar: :any_skip_relocation, big_sur:        "67328c03c13a86825399205ebad5765e9a5352c0999f7a213f9ae9087eeb0f1d"
    sha256 cellar: :any_skip_relocation, catalina:       "a4eadf5c1128a82b20396ed784c02488c570cee8b9ae7e555d2cab76d39638f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1974cd55654f559127a68818af132cd15f36b1f9ed9c365e3d25c3e980049b90"
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
