class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/v4.1.1.tar.gz"
  sha256 "8617afe9af8fd40ee2ddcf8ebc6464290a5a5fff0e5b5723e4e0f55b7604065e"
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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fb7f73c114a46f590717e42862fd2b95e6e9a596bc1ab4369eaab71d1e84064"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fb7f73c114a46f590717e42862fd2b95e6e9a596bc1ab4369eaab71d1e84064"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8fb7f73c114a46f590717e42862fd2b95e6e9a596bc1ab4369eaab71d1e84064"
    sha256 cellar: :any_skip_relocation, ventura:        "341932b24e8da6f666f87665fc59db797215150ecc86ced5d66b74591c94cb34"
    sha256 cellar: :any_skip_relocation, monterey:       "341932b24e8da6f666f87665fc59db797215150ecc86ced5d66b74591c94cb34"
    sha256 cellar: :any_skip_relocation, big_sur:        "341932b24e8da6f666f87665fc59db797215150ecc86ced5d66b74591c94cb34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "787d6b8e7fadfb7ba432ebb945a035e95d676e0f7a79af932a10af87a83379e6"
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
