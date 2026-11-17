class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/DNSControl/dnscontrol/archive/refs/tags/v5.9.0.tar.gz"
  sha256 "f40bf8efd3a92deb1b701af6ab6d26f537850a68d0f4edac9b84c874ed12630e"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "acacb00f1de9134086d8b90692046246b967cea01fb0c48c015b92229fcdc08b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bbdf5b53914b80213e5b038f9dabf1451dd4ce3204bfab876157122bfcc4b714"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8ae25a6a17e29a3cab3b7ca415e4a732d36da0bc8edc2c8d56abc890f6655fa4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "07590971e643441e76ae60c5b33e777a2238b0ed2460c5a8d8b4a3701a2c37b6"
    sha256 cellar: :any,                 x86_64_linux:      "b9a52104135171f52a4bc8cfc2bd18df3d49a15cc7702dd8d7579907e5ffd207"
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
