class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.19.0.tar.gz"
  sha256 "70720e89ef3bed8bb362faa0731ae8d30960b869bb45201d811f679daa2152dc"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c7da4f810167ba5c017dae64408dfb1e40e4818cc12236953dec2522cae1efc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c7da4f810167ba5c017dae64408dfb1e40e4818cc12236953dec2522cae1efc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c7da4f810167ba5c017dae64408dfb1e40e4818cc12236953dec2522cae1efc"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd2888686c3f860f9c36b11ee0ad9d81bcafaec16efa50dc7d890ae27b6e1f2e"
    sha256 cellar: :any_skip_relocation, ventura:       "bd2888686c3f860f9c36b11ee0ad9d81bcafaec16efa50dc7d890ae27b6e1f2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0ae511c86944458a254b7737f2406f8b8b7169858a5a449a72ec1ad8cad9df0"
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
