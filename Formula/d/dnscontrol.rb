class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.15.5.tar.gz"
  sha256 "baaf10cd3dd100b6676ae0f8a0b9fabc16b8971403a039ef2fa79a265ec600ba"
  license "MIT"
  version_scheme 1

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a91f5d888e9e7456b37e341f04bfaeefd49e804257f0578469a6ca6e3fb0407"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a91f5d888e9e7456b37e341f04bfaeefd49e804257f0578469a6ca6e3fb0407"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a91f5d888e9e7456b37e341f04bfaeefd49e804257f0578469a6ca6e3fb0407"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd5d40b1524e58bded5088771e7412cceb8ede382e6947e5b5b5d8a9067a7bbb"
    sha256 cellar: :any_skip_relocation, ventura:       "dd5d40b1524e58bded5088771e7412cceb8ede382e6947e5b5b5d8a9067a7bbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b6384c770ea5ac4421e5c1678adb21405d5124ab4187da593ea34404f789451"
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
