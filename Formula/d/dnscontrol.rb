class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.20.0.tar.gz"
  sha256 "61fae2bf6fe20a8bb2f4b3313ea4c3add3068e280a2fb74b02e18c8fbe65c17b"
  license "MIT"
  version_scheme 1
  head "https://github.com/StackExchange/dnscontrol.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f54d2ea13319f4a443232ababa883046ef17e9540b13d529e6742aa59c4bfc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f54d2ea13319f4a443232ababa883046ef17e9540b13d529e6742aa59c4bfc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f54d2ea13319f4a443232ababa883046ef17e9540b13d529e6742aa59c4bfc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "79337f7bc293a980233782d79a589ea16575830a3752e5c9ec45a85d9f1f89b0"
    sha256 cellar: :any_skip_relocation, ventura:       "79337f7bc293a980233782d79a589ea16575830a3752e5c9ec45a85d9f1f89b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "422724e41057b2e46794178106ab088ade3c5628b63365faca283e32effe1dcf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

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
