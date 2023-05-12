class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.31.5.tar.gz"
  sha256 "372814eaff7141b7f8d52cc027eb4bffcce7bcdd77e27529bc77245140be4bbd"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b09455a37af5c346dc2963be19fee4a8f91a0d0eadc63d7fcb761734a90cb44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b09455a37af5c346dc2963be19fee4a8f91a0d0eadc63d7fcb761734a90cb44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b09455a37af5c346dc2963be19fee4a8f91a0d0eadc63d7fcb761734a90cb44"
    sha256 cellar: :any_skip_relocation, ventura:        "22de0659cddbbd2907c31c9a15af2a660f919fd7c040b0f159ac238e8ffdda36"
    sha256 cellar: :any_skip_relocation, monterey:       "22de0659cddbbd2907c31c9a15af2a660f919fd7c040b0f159ac238e8ffdda36"
    sha256 cellar: :any_skip_relocation, big_sur:        "22de0659cddbbd2907c31c9a15af2a660f919fd7c040b0f159ac238e8ffdda36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "724e3a62a2fb38123c4c705c5e9c33846e6ec04aef716085d7414e8c1433cfc8"
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
