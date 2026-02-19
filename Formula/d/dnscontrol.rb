class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.34.0.tar.gz"
  sha256 "3ea3ef37000f4faa136210606dc62c8b908f4dd19e13b35748f664cdb2c2ef59"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61d353dd83160c5c671d8daa96c3ffdb170f906ef1e3331fd01b0b448b0614a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5089ab66091d3ccb5e10e811af088cab2a269586e0a519a7c9b36229c8abceda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "285801e7f744b812d3cc0e3a53d7d438a8a88077af7b75d8878cf394cbb8710a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d82d33fcaee185292f9122e605e9ad4727da02d97712145f01cee5e898cc1155"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "603f75ca978ec915d09cc4c2e9d740df269b6f3ebed87dcc6f4c6110c2e27a7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d4519394ad9f67ec8a3ace51d3e52ac8fc6d97a26e4d5e7dc2fb25058e98b0d"
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
