class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.10.1.tar.gz"
  sha256 "7467458c994072eb98dbfb73b9d6f1c3fa70dd0a7890dbdea3a5665a7e84ab3d"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0e719b4f3dd5985b85b413dabaa87e692af31539bfa082c387f4d8fb14544877"
    sha256 cellar: :any_skip_relocation, big_sur:       "a5cb6d0616898a7adb9d7cf69d073def4f2ff144da90f24a722099d90c045a94"
    sha256 cellar: :any_skip_relocation, catalina:      "d0c59069462b1862d460dca8523e1bc4f24b5b6b67d6db8113a2333f221723cb"
    sha256 cellar: :any_skip_relocation, mojave:        "3e5f21140661c0197ecf4fdba75cb91171cad2af09492ca0faeef9ca5f099dee"
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
