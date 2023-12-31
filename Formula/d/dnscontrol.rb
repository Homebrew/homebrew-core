class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.7.3.tar.gz"
  sha256 "4d60ffb84b62005156b8b28d4c212a675946eb7bee557856517822e5bf2c1539"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f41c25392a050a62cc2d0af19a2c8d7c90966ccdf605358ccd3be53b95010f05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80546bcef8bc13be64bc73b3f9197945f2a1712dc7046e82b7f658dffce2b7e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "639928c687cb93e1fd0d45d66b001ef044099f52496dc46e72a4fce4694289ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "652f38207eb14ab1287aa01e78fde52681bca8c46c2890708f9ea3e0b601bef5"
    sha256 cellar: :any_skip_relocation, ventura:        "518e58c5020311038291905f68c30c00254386bed898a28d57afcf8d0642f095"
    sha256 cellar: :any_skip_relocation, monterey:       "2c9e442bd767a870599f531b3afa6018df476308b40bbce0d54847f7d6f12d39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "229976458a0240634e4bce06850b85d02c524ea56fd65344da421da97e0e3aed"
  end

  depends_on "go" => :build

  def install
    go_ldflags = %W[
      -s -w
      -X main.SHA=#{tap.user}
      -X main.Version=#{version}
      -X main.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: go_ldflags)

    generate_completions_from_executable(bin/"dnscontrol", "shell-completion", shells: [:bash, :zsh])
  end

  def caveats
    "dnscontrol bash completion depends on the bash-completion package."
  end

  test do
    version_output = shell_output("#{bin}/dnscontrol version")
    assert_match version.to_s, version_output
    assert_match tap.user, version_output

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
