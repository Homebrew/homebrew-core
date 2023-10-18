class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/v4.5.0.tar.gz"
  sha256 "2afce3acb1451917090e988fee3d10a9c7ab922659d3431b4dcfd56178b05301"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d5afff15f67f15c3139ec89586b6fe167af95fb562b15ff6dc9844966710446"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d317f5d47cedd8721e89050930b82c168d5b1142fd7fdc1d6bbc433582f26ab6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56f864a59cef81fbd6d3bf20b18235ff0d248d793c27e893d3e27964f72b2a8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "643b0a74a096bd1bed1b6790c2ff290d13e31edba57c6e45201078109ffb9d6d"
    sha256 cellar: :any_skip_relocation, ventura:        "5f8278d7e847d3c6b51e470cb1fca6350543ee971145c3dbf7870bf604672398"
    sha256 cellar: :any_skip_relocation, monterey:       "9682fa048a73d769c61bf4a0bc5bcd7c2c6e18aab8d079cc70e8ee42d8858874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da778ad580f27938fc2ad9acd014e3fadbca587a51548bffcb653f128607ec6f"
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
