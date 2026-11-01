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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cdc5675e72b6611ed126cb627e5cde10ecba1ac3996950390068d25dc527f90e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "66c77c2af405a334c2ef41381bf21debeaa2a5e872908a9bd13c6e5853cc8e38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2640fedf5287fb86d7d424713930979577257d1afa192a3c475faac2a1895d30"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "825d5b74fe4cc0819578254aadbc5754a97182b158af2942a33f3d30171a06b8"
    sha256 cellar: :any,                 x86_64_linux:      "7bad4675717d45d0c1fed705ce7f586f68f2aca173eb0ea34b61b166ca877c75"
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
