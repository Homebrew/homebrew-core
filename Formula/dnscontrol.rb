class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.31.1.tar.gz"
  sha256 "bbc5d65a125e27905da5c634726cf033eb51b4121d4abb177844f4e77261c2f8"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1649fdecdcaa697672586acd85d3c35edce5beeed145420c953580480d5a7b09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e25955be4293f0e3bbb352ddb77a751081708262713429fa3127e7cb1778de4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6250d4dbed867c2dcd9d518cd8e1ef908bf110593f58c3c4b7909435e27e6935"
    sha256 cellar: :any_skip_relocation, ventura:        "0ab97da3c02b5c0ad3a8eba42ab5a7e0cbcb032482b592ccc418b7c58f2daae0"
    sha256 cellar: :any_skip_relocation, monterey:       "d592bbf7ea0e8f383a0aebb1a82f6ebce76ac7c9ed585d12a44af911c4da5d84"
    sha256 cellar: :any_skip_relocation, big_sur:        "f600b7d079c6dc67e78560dfde9365b9a6e7c00688df2f93884fd858e65e2c75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a90e46f00a38d79508cac2a7b9e3367a168bef89bd4f2f96712924038319e874"
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
