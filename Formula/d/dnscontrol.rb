class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/DNSControl/dnscontrol/archive/refs/tags/v5.10.0.tar.gz"
  sha256 "b5b77805bf9a032b1541f6649f9d06dc4b4956edb8bc624800d4a95f4664699c"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c50282f5dce3bafd1a4d7ae0895fc6fbbd125a13180b304afb21be0f7d262596"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f0f95dc038dcf126bb49b2ea2e0d1f28a4235f6fd1e3b314d5554bb5d87f0114"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "89bd33b324ad3961b7a8abb076284b36bf45670d931d9d5e16657e09c12a65d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9596466a3af46bae5e878bc889f53e777fe07b25be9cad9d700cf6614a76dcd5"
    sha256 cellar: :any,                 x86_64_linux:      "f78c99fc076a16ef3edd5d5c9a6a09198a47d8c0b60360dbf796790ce14d65cf"
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
