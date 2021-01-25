class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.5.0.tar.gz"
  sha256 "d90d5a54e5ea4c2e6bd296f950b3f9059dd1a5801e306b475421d6344489d917"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1edf810e9987ae2a366f0c0b230d1cecf64f79eaf8786f45f0e407e1d9df2afa" => :big_sur
    sha256 "959c5a1c54cb8c3b5094111b54344102db0d9f2223132c39a7822726b2e379a0" => :arm64_big_sur
    sha256 "7fd47fbb51172c89e6fb30a4ae7b6f43c6e7ec779af1270cc706f83b165e6306" => :catalina
    sha256 "f5c9c7d74265b48531453d8f01ddb60905bfc5046711dbbd64416ab137b588d8" => :mojave
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
