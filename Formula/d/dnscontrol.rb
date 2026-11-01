class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/DNSControl/dnscontrol/archive/refs/tags/v5.7.2.tar.gz"
  sha256 "910b66993020feb9d2a01c1abf623b3c861c0c0f16ea5b7bf83bde5ce3040d83"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d25eff2a39ff3fb4229be02318f35c44fd967c29189a16474682359323552e90"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2860995c13d740f3b99870b1cdacaa124d32c90c519c1004e74ba4294ea4cd5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7d651b25604762d6d5c26ccc51523c20b436b483898609a6ea221a9f5546e100"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f5b86983ab1b95cf90f861603c7d571c362bb68f0462df77da315192afd81cf2"
    sha256 cellar: :any,                 x86_64_linux:      "aef601abc3b71175136a5e7097fae85ef0d12aaa7fe69c575bf44194f76286f1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/DNSControl/dnscontrol/v#{version.major}/pkg/version.version=#{version}]
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
