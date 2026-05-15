class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/DNSControl/dnscontrol/archive/refs/tags/v4.38.0.tar.gz"
  sha256 "ceaf6a608ceea2660880d598ad8f32299a0959c7eb76bf531e882df7b7c7ead2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2ffe9a83051679fc88f7beb53ff8a347fd6a00d4d4f23181213c70099ffe415"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2064375c6bb24e9435c166898d511833b3a39166a6f59122d0a5840e47201a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fda1a22ac7cb719ca51f59db7f39e30c8c8c88c32772d4ff8de6c71130877395"
    sha256 cellar: :any_skip_relocation, sonoma:        "35a8b654083c7d310a12af6a50cb53c3a7a73c9ac57266cd809dab5c3aa8863d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "057a90249d04b8930bab42723f011601821f021cd7ad4b93e42fc7e256e8a50b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d780b09808d3d685d102b3d109822d93189e7be28fc6f8b85521cf7e588f6a80"
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
