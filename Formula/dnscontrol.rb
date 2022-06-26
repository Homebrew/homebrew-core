class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.17.0.tar.gz"
  sha256 "29146e3ae9d6936ffc846b81f769d019d931286ab8da664c8a261a33ef56cafe"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6ac2628c5936f582d98a046343e5cf2fc73ef70b7a3698f9c6d2c7bbc0ca474"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "098eecfc247fd7c21c144b56311a86cd30ee4bec7eec88444ba35963669c020c"
    sha256 cellar: :any_skip_relocation, monterey:       "2a5f87ac47f34096d43b3c2f31c2fdcc90c62c0dae4b9a203faeddac06055f49"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0ffd740cb73e0b7fe7688f34c15258089005872f1d9ed42b54f361fb9aa383d"
    sha256 cellar: :any_skip_relocation, catalina:       "8c63b02c49a26aac47d25f25da4d8e89604caa254561ca4c9737a5a7139f3fdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fbac36b30afe2d97fe59f6fd3609af1be3bbe97866b4e1bdf427d630cb3ceb3"
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
