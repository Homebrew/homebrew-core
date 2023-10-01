class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/v4.4.1.tar.gz"
  sha256 "ace92223edd68705ed5c3cee889cb65c73f9b0661cda7dced1218fa3222514ee"
  license "MIT"
  version_scheme 1

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00ff3b2ebeed40e89e08e72161a7e503cabfa1e823fb860ddc098334c31bcff9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a9d84b8e42557886642108ddc4afc3a431fc243235f0779f5b99bdcbe517612"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19a3d841535defc5e6c80831df864a9640ae3117bc931d870cccea46778073d1"
    sha256 cellar: :any_skip_relocation, ventura:        "d91708a2c2d58e904626592b0a60b4d90eb53c5908e198f87b9943fbe9eabd4a"
    sha256 cellar: :any_skip_relocation, monterey:       "82a200eaeaeb07334fdae4aa87a4128560b954080042f1c67a02297a24c543de"
    sha256 cellar: :any_skip_relocation, big_sur:        "479821a968b3ebdf7a84cc817fa779bb0a6e05775bf47245f31682f5e41d329a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6f9f11b00d81d042a5b53a7e00aa5761e893b4fc56d22e9fb238427a79323a5"
  end

  depends_on "go" => :build

  def install
    go_ldflags = %W[
      -s -w
      -X main.SHA=#{tap.user}
      -X main.Version=#{version}
      -X main.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: go_ldflags)
  end

  test do
    version_output = shell_output("#{bin}/dnscontrol version")
    assert_match version.to_s, version_output
    assert_match tap.user, version_output

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
