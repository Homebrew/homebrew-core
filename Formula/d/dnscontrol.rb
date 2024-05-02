class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.9.0.tar.gz"
  sha256 "b07160a30052d9923be2d6af4a681822d284b43b3a33ce5b472123a4cbf108e3"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1bd3676b84b5060cd2883f83ef4fed3122f72cc16d34591a0aa440a604873346"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea2fa2c3de1d0e13190045cf51e8365ca7fdb06fbe5667a2540bc86ede421a50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "511f8a26da30d7a43bb58f2808f581504323d89c288f6d0e509245cf2b926441"
    sha256 cellar: :any_skip_relocation, sonoma:         "112dc9caef7ab0fb1892a4c6f1f44033c009412dab9631b2f06de649c5ed9b16"
    sha256 cellar: :any_skip_relocation, ventura:        "dff1e0092bafd91579d4061f4a2b22afa79bd476285fadab8a2817371a9473bf"
    sha256 cellar: :any_skip_relocation, monterey:       "f9cb16e7c6f61b2416255335c7221c4160ca5f58cca21325cb5be5989d7fb915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4b319665e2ea1822f1e67405e9aaade11f407f66b6f30c626f18ece4d689f16"
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
