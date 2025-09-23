class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.25.0.tar.gz"
  sha256 "56738616f2783c8c7deb306646f88cad1615c8c0dfb995e1110162536e7cb043"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c65534a35178427c4c4aeea09ac462bb040128f0566b75e95f9186fee60aeaa1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c65534a35178427c4c4aeea09ac462bb040128f0566b75e95f9186fee60aeaa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c65534a35178427c4c4aeea09ac462bb040128f0566b75e95f9186fee60aeaa1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c46381571f24fdffa4f45b81968af7bdc4956e792d88bcc3df191b983fe81a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "428b5bf05d0361184ad8e6860a07448609c94f7d694ec552a901162db98ec5de"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/StackExchange/dnscontrol/v4/pkg/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

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
