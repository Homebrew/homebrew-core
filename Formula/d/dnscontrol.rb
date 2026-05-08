class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/DNSControl/dnscontrol/archive/refs/tags/v4.37.1.tar.gz"
  sha256 "144068a45d50cd0685bbb947384b55a6255c13960649c5d0c5278532d69df423"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1af103138f623776cccf8c5e807582621f8be1a0f76e058daaf670bb4bb9ac9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c79109900aef81e9d69cc7a050d93efc963f3d64deff6406abe884d5bad77c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dd24b2df102e50b23794b612ecc62d1ef1ce18098af4fab1c0995eba712c9e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e38d4405df9a8f3310687436849c1f5d23aac677456cdc90ca8812102752a64d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1f1ecd1951a87d84e4a6dc79173a2425ab3d5be1142c8f6f7a7bca9a23d8de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc43c3fa417616c58fc6e5d4d21f0621be785946555a57ac00bacf5204d97443"
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
