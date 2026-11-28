class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/DNSControl/dnscontrol/archive/refs/tags/v5.10.1.tar.gz"
  sha256 "fe792b4d2121b21bb469e3231300f0e567eaba2aecfeabc43049a10875283989"
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
    manifest_sha256 "e85ba8d22409dc973c8944a8ed5de82bcc3c2f9d2b6344b641f7d798e5d27cf4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b0099d18eaa50842501156f24c5256c75e37499bbc4c4f13c2bcc924f90cbae9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4fc826950c6275903121068c948c462eb4c2b0cac490f0bf734d8ed7c4662c37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f0c0cd0e8b680db3c7f62699fdbe00526d2f02554fd2216312df58f66ace316f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "53c6632c12561b34c274d6ffd62c30d19dd8d228574f66ffe2c0d3006d78db76"
    sha256 cellar: :any,                 x86_64_linux:      "07a59cf44257262dd0d4a57e1f25edb23dbf67659d72e3576849edc3e97b9c50"
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
