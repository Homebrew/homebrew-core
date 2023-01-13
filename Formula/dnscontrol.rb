class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.24.0.tar.gz"
  sha256 "1aff1a1e1dc033e545b296823e4d4d2958c3d450a3eafff20e391767198c41cb"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7571bc2edbaf45c309aca02fc7172b90bda15fa1de2ed04094b79bf49f25b2dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79397279b4313994a248592c1a5fe15e9dff7e2d14a2fa5e67fb313d08dfd52b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "062c7072bf4c7365ef467b6255f3d81d7c58688734654686e0a871e463bff52b"
    sha256 cellar: :any_skip_relocation, ventura:        "d0e3332c1677522bd6c3770073905f27140a094a010fa866d028c69119f45ce2"
    sha256 cellar: :any_skip_relocation, monterey:       "5969510f08ea414b1f49ef5cf412a45b58177e7c45444cec68fe30a930d52350"
    sha256 cellar: :any_skip_relocation, big_sur:        "3924c5bf966334d90a8b6083f52147cfd3cf55af2ffffe0477fe4262df7e1aff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "840b32899222ecc6304a7f1319fd9201fc91d1e3a1593d88d2d28f1f8d14df1a"
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
