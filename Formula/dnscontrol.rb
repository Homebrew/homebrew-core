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
    sha256 "8906362c28b24bc8ae785e04af4b47aec88990b7997d506a04b18d8ff012bdf7" => :big_sur
    sha256 "df82003753250c3f12760649ac55e25290b28e215969568425ac5c66845a255c" => :arm64_big_sur
    sha256 "edbbbb1a026a05213b47eaf62f8ba7b202856a92ff810f3d66a4b0591d303414" => :catalina
    sha256 "b4d364509175f080eaa344c99bd6698c813e3481c344eec5e1d5e8594bef649a" => :mojave
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
