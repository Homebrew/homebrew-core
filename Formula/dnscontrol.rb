class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.11.0.tar.gz"
  sha256 "a931b0e1c2173327b768895a40a9ca8745faf0ee195bf94c29f47232506fdb6a"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a53058bf18b78c0f4fd6fa8b04b7f74be5cd28c86191ef6c86f2f26356507249"
    sha256 cellar: :any_skip_relocation, big_sur:       "ce17d4d116fefa78f1c4f69ade046a68aca25ee5314e3f630ef4e6dbeda7d8e9"
    sha256 cellar: :any_skip_relocation, catalina:      "2832b19af2db8cee71c35f6ddb6430e6e59c1a38bbfd7484c9157b6e43631e2a"
    sha256 cellar: :any_skip_relocation, mojave:        "50378caedeae277f278909adb73ee69594b4b2146a523f791669e36a976bc02f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba8c63c18e962aad14d4d2c6a7d6ba53a590de40f486b53cfa7b5811d22c805f"
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
