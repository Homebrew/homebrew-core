class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/DNSControl/dnscontrol/archive/refs/tags/v5.5.0.tar.gz"
  sha256 "79b27ff18638ff71f8a001aca0da4b0a320e02d7bcedbdc001377bcec0a64833"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ef1492e899111b9095ea9e1757582ca658314b57dd36b457e496ee86ae05915c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b0aea218d45fcef3aa5962b06cc086c26a7fa2dc69ca95c100d2fe59438bda4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9b3aed6a0475937cdbe5b46f89c8149ddd302120239dbb1b2c17163621c85540"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bb94b3b7d39257316ffbfdd722c2baabc7dd35781e0bff14d4069656585fd362"
    sha256 cellar: :any,                 x86_64_linux:      "e6da9f30a95895f5181720adbfdba69638b9ad6191ff3917b8dd7bcf465e4634"
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
