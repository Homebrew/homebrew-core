class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.18.1.tar.gz"
  sha256 "5a5c10aae761d6a6053b2ee01faa540d7eb196b68575adc7d5cfbfc28e8e7ce6"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a68d1c523a04e2d1399dd9b96dc4a4bcc922b8b456401ebbd2795da38742ee70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "742823dd66dee9316302382b123e93c2db12787e88a63d369a7b7dc60f0a442b"
    sha256 cellar: :any_skip_relocation, monterey:       "29f50b0acfb9eb23469d8904abac28b8fce9ae7073aece07f2079f2098e228ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "527a7c2e70e6314a7dd76e6d4f155b04c6f8ab87282174f957563064af4ed39a"
    sha256 cellar: :any_skip_relocation, catalina:       "73711d742315286d36e8a54cf3a3d5c10498964a54ca5361897a9c0af6990477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b9f7d9a50b90727b33d3a73d38bc4a655f7945a877271a2a580b833b87e9d76"
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
