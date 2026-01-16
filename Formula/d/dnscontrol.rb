class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.30.0.tar.gz"
  sha256 "acb945323a87afd0d5b449446f806dc5491a52571f525921725620650074ff89"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8434005e2e0702f3736b80efcac7ae5aab69b48e36d34051eb9bf625cad1d000"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45cfa6740e3000420541347624c3df893315b8be4471359d363c83e693c9c19f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f5550887e2dd92a703bc7f645255ae3ca20ec95d3120722f21b658f12b09b9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f7f8ad8d1dc5c6953cf0021fd272f806cddb7d4578a3f77d5ac848eb3339afa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b58fafc847b89ef764aa6114800d7784c3e57e0ea344ec0c38f37081631cdf8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5315383514b3b515165cbb2cb72945a6bff1a943645d376a9c75031b257bec8f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/StackExchange/dnscontrol/v4/pkg/version.version=#{version}
    ]
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
