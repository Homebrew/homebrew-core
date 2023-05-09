class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.31.5.tar.gz"
  sha256 "051a6e5c14b7f44527e45a1e2189363af0c9da2de1c1a01feb32cecf2dd9c32d"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96399c5304c78289275051d96e81bf483887ffc4a782fc59847a86b37cbfaec2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96399c5304c78289275051d96e81bf483887ffc4a782fc59847a86b37cbfaec2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96399c5304c78289275051d96e81bf483887ffc4a782fc59847a86b37cbfaec2"
    sha256 cellar: :any_skip_relocation, ventura:        "bb4818f7b6461274343b60fb930c46463cc03e6eb4fc8d5bfbed39cfb8ef42e3"
    sha256 cellar: :any_skip_relocation, monterey:       "bb4818f7b6461274343b60fb930c46463cc03e6eb4fc8d5bfbed39cfb8ef42e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb4818f7b6461274343b60fb930c46463cc03e6eb4fc8d5bfbed39cfb8ef42e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d26bb8e5b7ce908a7a8f10bf96f15572762f96c59283b0c63b12eedcb8a01a19"
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
