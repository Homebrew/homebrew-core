class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/DNSControl/dnscontrol/archive/refs/tags/v5.0.3.tar.gz"
  sha256 "a5a9d5949f3bbbd738a714e51d0fecc15fc0446601ff852cceb142a593aee0cd"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d35e959829f4602f2d9ef5e6189da5b029ec46e3583584fdc559aa46176c24a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9d1cb38c961f9fe1823392d8e61a44c0628872e2ab1df9c07f688c5eeca7777"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c217faf501b4a6356a656838ee814da59d97235ba1d5169d078a627644d74e44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45338af3f642d7fedf67077da62ecdf8e4e9049cb1be6493e9c7907fe98f2060"
    sha256 cellar: :any,                 x86_64_linux:  "a2360a9ec568352a65db17c920bf25b3d251a0776b91f8abb7624622bc105910"
  end

  depends_on "go" => :build

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
