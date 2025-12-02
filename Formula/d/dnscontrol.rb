class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.27.1.tar.gz"
  sha256 "42d4202658f7173b15110ce3201efbf25efdf2910cd75ee60a57a4435c8eb8e6"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9378c6f3ae45e2a304fd869b89010c1125aeb95de56e9f7d72d5168943a74150"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9378c6f3ae45e2a304fd869b89010c1125aeb95de56e9f7d72d5168943a74150"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9378c6f3ae45e2a304fd869b89010c1125aeb95de56e9f7d72d5168943a74150"
    sha256 cellar: :any_skip_relocation, sonoma:        "00546857abf7da2a4ae59168cb26d6fea0706c121c820806f0392821a2df9cf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a1621ef5ee58f26bbfb953ee18d880c3e4270eedec6629c36f569d76ded7550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62a806b499bda9c11dd83682101d334e66756b179f58fb1b929bd4aae6724cb7"
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
