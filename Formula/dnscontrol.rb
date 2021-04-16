class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.8.0.tar.gz"
  sha256 "a8fceae91a39c63a30b66a7c65dc93573cd73e3842fef4d9412ceead63a620a3"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "127759111cd7a0b4d85cc6ff8889f57429954cdab4029d4efcb7c092b39f5acb"
    sha256 cellar: :any_skip_relocation, big_sur:       "82dd7f8359359110162127a6434b88188a8d83a53053f68a154ff2cf16ca6b58"
    sha256 cellar: :any_skip_relocation, catalina:      "f53e918934f4346dba2d50adf7f1d310fb752e9e9ba387716e6629a1b3919636"
    sha256 cellar: :any_skip_relocation, mojave:        "2ff5b255b9d4bd3d067f0cbfdf77e4c42ad2023f64abc0da88db29e0d86facb0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
    prefix.install_metafiles
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
