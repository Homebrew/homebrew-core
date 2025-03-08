class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.17.0.tar.gz"
  sha256 "e126665a00eb0a7983ed2dd5a61ac84d597e3e8016fc010d2bac7f1bbe90d201"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00064d83d075a7eb8e4a73326cb70e221a023174921e7a35622a66a30f864b06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00064d83d075a7eb8e4a73326cb70e221a023174921e7a35622a66a30f864b06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00064d83d075a7eb8e4a73326cb70e221a023174921e7a35622a66a30f864b06"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfa7dc021a749ab477ced9c3199a2af2f70d3d75622789b49e33bcb968628626"
    sha256 cellar: :any_skip_relocation, ventura:       "cfa7dc021a749ab477ced9c3199a2af2f70d3d75622789b49e33bcb968628626"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d34f30a11e279cc373f44b4c1eac01ee8f66e257bf417f0d65e2e32eb96d6e14"
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
