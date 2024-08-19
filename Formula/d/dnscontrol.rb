class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.12.5.tar.gz"
  sha256 "c4c4bec6f49f48deee3cb7f611f3ebd42ff1ccabd35d856ab694bdd6e07b7203"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5add366f87f58f5a28d4ffb7474ded6e04a0909850f9041e25d21b216b1a1d50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c48997e25a871409e5c4641717dba5af4624217a68e5c808fe3f93e487b8016"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de044a5e5a7f302e763fe74c051f309747b918bce0e0867474501e0853b0195c"
    sha256 cellar: :any_skip_relocation, sonoma:         "89be23661b077bf7261d0cf1a21881c540360083d10aae8e4e5b7439e01cacea"
    sha256 cellar: :any_skip_relocation, ventura:        "06ceb16590b455534a74f6cf8f49a771a9bbce202865e23f3a354c8c2901b7dd"
    sha256 cellar: :any_skip_relocation, monterey:       "2d2577e2c3bd71e6f7da1ce4b7765dbe74e3082228cd0720a2dd273a64426518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea1c50d03707b9b4318adb8ed17989fc4607b0cd95b7230219fed391cf54c796"
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
