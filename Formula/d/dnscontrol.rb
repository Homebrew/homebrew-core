class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/DNSControl/dnscontrol/archive/refs/tags/v4.41.0.tar.gz"
  sha256 "df5004390a8e859c5dbac1a4cbf86cd452fc15706add4df26c7db03146af8cdd"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95536571e775f667c17e5dc00c66cf73c04f53f101ba19746526c7ce3b675250"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07f313ab7067197f90ae42ac58e49a2737f3d6721c380efca6ceae0a7d45dd08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6f69b352aa368dfa9dbef9b39c0b8d93e2fbd681b698b62f21e0d627280efad"
    sha256 cellar: :any_skip_relocation, sonoma:        "299062151b17756861e137cce804c80f89a4754d1093fb9c6390af590da3c3e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba3184a6600082b5d418f666d31759c1f8bdea142c713b25b32b5b2b02756eea"
    sha256 cellar: :any,                 x86_64_linux:  "f6d6e3cc5b06cfb3d3081ef5086cd121cf3d569efdf12e601fea45cca3e9d9a6"
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
