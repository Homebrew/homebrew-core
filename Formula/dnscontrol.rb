class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.4.2.tar.gz"
  sha256 "3847e3f38c4da400c6f5819fe3fd8f6ad0e5f2e769970390fc42994a79775b79"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "59fa2b6cce2d8e0ef1e129f6e2864a024b70ae97c13f439cb02a0116e1458081" => :catalina
    sha256 "df9dc00d6618943aaa24f1658c28651209c7e257df4eca91471fbf89b9a918d9" => :mojave
    sha256 "7dbafdd2344519f503f3e9cbaac7a208b6c45db02ba5a2b6f0cb64b3d392a53c" => :high_sierra
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
