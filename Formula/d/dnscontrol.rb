class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/DNSControl/dnscontrol/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "f72c16f08b5d407ece46fc173fbe208c85227dd08889bc3abe9ed6e4e5060f28"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5717e6882e91d3b1d3a6e4133fcd8e40209d9ddb1beb351003f37f633a6703c5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3961ce3c94b547d8ee9cbdf2e0ef1db7767eb29333348f35fa07ddee8e0ad0ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c2855a9325c371323ebe14bafda2d133d4d89f72e635cbb19eeb4f820d3f46bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a1d02ddef32e6424140c814bc55fe7837f85621aca4daa7109d0aa5d68004f1d"
    sha256 cellar: :any,                 x86_64_linux:      "5517611c4e6ffb2819564b762569015c252e8e8f661ee202f62868e4bf5d5c30"
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
