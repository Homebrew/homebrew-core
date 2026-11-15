class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/DNSControl/dnscontrol/archive/refs/tags/v5.8.2.tar.gz"
  sha256 "6a99160430ce10090cdfe21668e26953df12c34198d98685d42716cce2890c95"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3e09e916a3114fec4f653c296af42ab2670f8cb9ccca79173bd9646018fb50d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a13768f42aca74e70d3fd27d22683e073320544913a2f260c0b2e1e921cb8e84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9010b47f45852fbdc5a3df672c798a90f21712ac5b50abd8b381475e133203e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d27b5a7f036a2fe29bfff9e056b91ad0870fdacae194f186ea247cd36bc05322"
    sha256 cellar: :any,                 x86_64_linux:      "085b334a9044a6da7c1a3682c5bd074ab6511bbaa482316e795700f2b620d1ee"
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
