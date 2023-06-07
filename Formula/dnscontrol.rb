class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/v4.1.1.tar.gz"
  sha256 "8617afe9af8fd40ee2ddcf8ebc6464290a5a5fff0e5b5723e4e0f55b7604065e"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eca81dac3262fbb4333628cad05ad4bed9086b0f7017f4664973d610a3d129a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eca81dac3262fbb4333628cad05ad4bed9086b0f7017f4664973d610a3d129a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eca81dac3262fbb4333628cad05ad4bed9086b0f7017f4664973d610a3d129a4"
    sha256 cellar: :any_skip_relocation, ventura:        "259ef847964715de87066cdeee3a0a543342555ac6cf85eed947c9f66497bb24"
    sha256 cellar: :any_skip_relocation, monterey:       "259ef847964715de87066cdeee3a0a543342555ac6cf85eed947c9f66497bb24"
    sha256 cellar: :any_skip_relocation, big_sur:        "259ef847964715de87066cdeee3a0a543342555ac6cf85eed947c9f66497bb24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8068133544c1762c1524cc4be9219b1cceabd2a0706a8948661e3ba6ab16a655"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"dnsconfig.js").write <<~EOS
      var namecom = NewRegistrar("name.com", "NAMEDOTCOM");
      var r53 = NewDnsProvider("r53", "ROUTE53")

      D("example.com", namecom, DnsProvider(r53),
        A("@", "1.2.3.4"),
        CNAME("www","@"),
        MX("@",5,"mail.myserver.com."),
        A("test", "5.6.7.8")
      )
    EOS

    output = shell_output("#{bin}/dnscontrol check #{testpath}/dnsconfig.js 2>&1").strip
    assert_equal "No errors.", output
  end
end
