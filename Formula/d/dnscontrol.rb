class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/DNSControl/dnscontrol/archive/refs/tags/v5.8.0.tar.gz"
  sha256 "41f70d77f7bd24c63d540075e453d6a3a0d680212b806dca2d069786f0b1fb81"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c6d562cdab48d22ea53a0d1a60536258f20facd0e1de4802188301ca4b8b7f36"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "35c6e23bc20c78cb14bd6b35414582f22f357455206a152923ea3e16ddd3d07f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d26d3c0fd9259ddfe38c3d3d10dc8e5fe3b7bf725c25c2cca061e87b330d74db"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "39179cbb95d0c4f4abd83d79bf49dd41f2c2cf18c5b5f2160ef3524a3f2001ba"
    sha256 cellar: :any,                 x86_64_linux:      "1d324e736b9e7f5542e53d46822697bb2e03c6d178d7994227dcaf6f15ca0eec"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/DNSControl/dnscontrol/v#{version.major}/pkg/version.version=#{version}]
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
