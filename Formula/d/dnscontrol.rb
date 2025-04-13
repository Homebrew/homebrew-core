class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.18.0.tar.gz"
  sha256 "ab1f228cdc87351754186000bcd9966f0bc1a1ccfc790aa61e9b103c944c4b3c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a547b724ca54639186b5d581915e50bde201771b85a4fbada775bc615bd4270"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a547b724ca54639186b5d581915e50bde201771b85a4fbada775bc615bd4270"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a547b724ca54639186b5d581915e50bde201771b85a4fbada775bc615bd4270"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f6a6e88b0abc727070b7fcd19dc206820e086272ce5aa7c0e3a6bd7f5307fec"
    sha256 cellar: :any_skip_relocation, ventura:       "7f6a6e88b0abc727070b7fcd19dc206820e086272ce5aa7c0e3a6bd7f5307fec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b3b15142d86a03606500a2057f453085890b0dde0dd2f7dd088fc9a8ad11357"
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
