class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.15.0.tar.gz"
  sha256 "6766667e85ffd128f6f486f44ceb01e8c18442252a181d54b9c754637162d685"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f7c8e704605cb6eb5460dc57a0ac6a10cc43a4d3930fd21f1faa7898d3a618a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28621a7e3ae0d50c76c21849e620b20019f1dfd26b1fba08697badcddd249e7c"
    sha256 cellar: :any_skip_relocation, monterey:       "d118147d5bcc4c82b974d54f20a2bd2cd6d0598552b75031a5b9f4102caf7609"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c68ffa859b486e9c1b26f1add16ca85f03f2b3330a0a1c1b69caa2b112cd4c2"
    sha256 cellar: :any_skip_relocation, catalina:       "13965869abdf3d006fbb7f9da105c8f47935d96c5ee5ed3e05fd7cab7a2ef299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b45397693e8f912a9ad35732b5cf6f7fc2dfde92cb8e9b9592fdb6377e347388"
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
