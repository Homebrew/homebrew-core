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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c32fdb2995aba8c6d9fc1f7d5f11063f530768203907a706da3c52cd407b625"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "755c1dfecb770a586c749cde55a8965ca2a8868f4d65cce81e4444e65c4c5203"
    sha256 cellar: :any_skip_relocation, monterey:       "1a3d68c80c44e77dc942dfd728a0dd789c69314427a845362671f659c82219ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f1e727e118b8ba9f1df76e92476965fb3cded82de3c3e535722bb1d5bd5f5de"
    sha256 cellar: :any_skip_relocation, catalina:       "d69fe0ed0a43a192e87749f8ce44272a025769de444462b20dce50a41e9e82d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73ece0c1a74196fb0a7779bbf319e420f77a6120f91bb1c713b48520b243285a"
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
