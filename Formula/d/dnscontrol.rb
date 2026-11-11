class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/DNSControl/dnscontrol/archive/refs/tags/v5.8.1.tar.gz"
  sha256 "71d0a9e71487dce36ece540bba14920d9ea6fb4dea3d1873aac0eeb250e63757"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e7eeaa35b04adb6c76e18796d5c08f8589fb78d2e534d6836f7e780daa9c7d95"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8151f194470c588744b0a0a0f127a831bb78ce8f257acf5122617fd653c97b89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "94bb41dfb07db7e0ec8773e11e7a935a2f481ffb86aa8b459bfd7701f5af956c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "21ceb8eb4d6dd5f45df00f95746548ae5b08c13f8911e52fd2ace5d15a056626"
    sha256 cellar: :any,                 x86_64_linux:      "52b385c05d94531d6c59259259afea71fb3782d341a9bc3f0dc848f673d26b5b"
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
