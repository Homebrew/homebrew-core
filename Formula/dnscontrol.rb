class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.23.0.tar.gz"
  sha256 "2a486e85105428d96b99271e012d8cdd85135d336c7fca31e68b4920470e4629"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c467f205d0c76660eca728bd3b2b1505e6ef31dd49acf9dffdd15613ee4fd67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cfa6b3de2d34611bc83905a6ad41153eafa2012b3f34085d5ef4e2388b13198"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9824a6e0227af9cbf26f706dbc0b504f67f7591a73b692d35227202a6f061075"
    sha256 cellar: :any_skip_relocation, ventura:        "cfb900f7e55567de84f8e51f9d22b1184ba976a7b5adc6369620f6991c76cb0b"
    sha256 cellar: :any_skip_relocation, monterey:       "edf1383c9b3430ec35952e2649348317cd0c4a00ff79c33791243bbb1125d748"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c75837c3fb8e558dfdbeef7c8858142ea89d27e76fe467c4a5502558c71e351"
    sha256 cellar: :any_skip_relocation, catalina:       "4ba827a0f640ca5392b3b53608e3de37c791d388cc5eeec68f090ab8fd47900d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6239631d6e1db8290276cf50f8c839a5c0a9ac81f751b8121ff548f9c0c6a8c8"
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
