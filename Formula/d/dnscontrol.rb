class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/DNSControl/dnscontrol/archive/refs/tags/v4.44.1.tar.gz"
  sha256 "5c58f8d7dff6463c2cd7cfdafd839f611de5c0ba77658b6cf0de3752a53298ed"
  license "MIT"
  version_scheme 1
  head "https://github.com/DNSControl/dnscontrol.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "162f78ee7fac258facaa9d568dccbd2229100a03d2f3325a91241e131d3c614d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d37e988b0d82a10f412c51934f10b419e2e2dde336396ab16e5a276cd653414"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ef81051888b3518d42cd4af6210fc10b458d4db03fcf02ea49c0b06dbd7eed0"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc9380ab9d2718246352fbb1bedc870607166394e74d5f08b29236e4f6ad4fef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f98fd37d1bf2942bb9b10abdaffa29aedde7415502b652868fb802dd8d8e9f9"
    sha256 cellar: :any,                 x86_64_linux:  "6e79dc9b1919b8fc80d2861e9fd2073e3d81a2f013e77d7eb0dfbfdaeff2087c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/DNSControl/dnscontrol/v#{version.major}/pkg/version.version=#{version}
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
