class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.21.0.tar.gz"
  sha256 "fb28227d0b94e0fa645989ea811dde9ec1ba272fb8ed5b1011788a710ffde3a8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b248ea6ddf555db3af61cc6b61888c134ef58168b26fd82e0c9c4dcd656b993"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b248ea6ddf555db3af61cc6b61888c134ef58168b26fd82e0c9c4dcd656b993"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b248ea6ddf555db3af61cc6b61888c134ef58168b26fd82e0c9c4dcd656b993"
    sha256 cellar: :any_skip_relocation, sonoma:        "725f7978eeb373a6acf8c9d15a094f0eb388358c94c71103ead212914863bf55"
    sha256 cellar: :any_skip_relocation, ventura:       "725f7978eeb373a6acf8c9d15a094f0eb388358c94c71103ead212914863bf55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0608c072b8e3f107309cd59649fec32e864c0d32d5ef5b1373079c5cdce3b16c"
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
