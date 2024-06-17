class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.11.0.tar.gz"
  sha256 "f27175935aa8fc66b6fc00a78edb62f8c6405492449a9b61bf917798ad326fbb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36c474c5df678115e66fadad994e8e90d08526ac5f236fcae58deb003454f423"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c7edfb0107405087314567a6b189f919cd9965b93ad3f4950526d4f6d3d8d50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4aa6579d497b3086cd746d4da0196fa706bfff3854f48b22f8f7d8d033f5db72"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f3a47efd14b1a84005c2df93c0cc2ed99bbb17491ec69aacc5929cf521821cf"
    sha256 cellar: :any_skip_relocation, ventura:        "c5182f17ce4c51aa95a221a1f28579d8e5db1fce77877514fffdbca7db1e76af"
    sha256 cellar: :any_skip_relocation, monterey:       "8c616636a3ea281d64a589d4a15350cedd7e3faedb15b34d8356efbaad960a84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "931e84053014464111b56a3ac0c870e6497dc42b6bc90c216f52ccecc22866d7"
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
