class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.31.0.tar.gz"
  sha256 "eeca64c5d0a22fbbe02ad1a093f283be9f423a581436d111440374931f74da5c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07a4507e8a7cd88fb391cb9f6e6b3e678f8cc773a021f541be3e82c617834775"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b1d70236011bcdbcd8ed6afdb1b591b31b9dd1f1606327bbf88cac164fb9c11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ac7c80ad834acd0b1b5f3339d663bf7e14c55452d522f1aa8f10976bf30e7bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a80c6785a32ab6a9a65526cd6d3f5171a0f2f59ae54930c042ae1aad0654bc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6559e21b80646264cfbbee758c81123d40f7cd771f06d147c25bc5d7af1ab17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcc822486d0808fe9fef07e36a645a4c0f086b45b84c3cbb8ee4eac28b15b9f6"
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
