class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/DNSControl/dnscontrol/archive/refs/tags/v4.42.0.tar.gz"
  sha256 "db08d6e6b07b4eeb5e8be6ddaec56023e53f39d68b1073de9ea0d4d62df47dda"
  license "MIT"
  version_scheme 1
  head "https://github.com/DNSControl/dnscontrol.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "776f3283808a98dfbbba834eef250a4b91f96f526c197015c4e4e126dd7ce1b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b545f898c7f88a844ee1c6f947627e3b842e1b1b5a963af3f8ad0ab1f0f31e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b4cfc01ac0cd1bc43a5d46ecb2402da1f95c8b10a6c9b4fc8ba3bcaa221f401"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a3429090d7182489e25d7ca0820a31445782bea79ea1adbff37e4e6a14bf877"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e359a1f715d74c460893a701483c282c5713208ced5486c6966d13d0fdbc701e"
    sha256 cellar: :any,                 x86_64_linux:  "0232ba9eeba102471c1bb1446ca4cb126251e9186c5b9daef6476d50c0e9b163"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/DNSControl/dnscontrol/v#{version.major}/pkg/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"dnscontrol", "shell-completion", shells: [:bash, :zsh])
  end

  def caveats
    "dnscontrol bash completion depends on the bash-completion package."
  end

  test do
    version_output = shell_output("#{bin}/dnscontrol version")
    assert_match version.to_s, version_output

    (testpath/"dnsconfig.js").write <<~JS
      var namecom = NewRegistrar("name.com", "NAMEDOTCOM");
      var r53 = NewDnsProvider("r53", "ROUTE53")

      D("example.com", namecom, DnsProvider(r53),
        A("@", "1.2.3.4"),
        CNAME("www","@"),
        MX("@",5,"mail.myserver.com."),
        A("test", "5.6.7.8")
      )
    JS

    output = shell_output("#{bin}/dnscontrol check #{testpath}/dnsconfig.js 2>&1").strip
    assert_equal "No errors.", output
  end
end
