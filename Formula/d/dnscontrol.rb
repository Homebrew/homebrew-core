class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.10.0.tar.gz"
  sha256 "a1b77bcd53d689abdc873ebe42dcd9129d88ec72095f5a1550dfd1f5e81a3e9e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7032c51a88444aeff4c3c7dd2cf0e81d6b027f2313b0252b0d4adea3d71ad52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3aaf24aacfe7fa592b4d97a2a93e1e703c373080dfe030ec3296687b75a07f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb4c0d6192c7904f2875e43d59ff332e9ff7938b331ff7ab74c79167d4fbb2dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "073e319192c27d4f2a1cc223bacd33eccd230fe2e35c12f82859c9ed205c9f93"
    sha256 cellar: :any_skip_relocation, ventura:        "66ff796926f253b9f0c813be592b8c45c438834ed887e714ec2f12eccf8a7161"
    sha256 cellar: :any_skip_relocation, monterey:       "b9c1e9e52ea1bbed46f3300ddce5496ff947ec97c7a83dacac1d2dd83cd1fb14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69f18285924dec3a5c7fd1a5ef961500dac6eb48d12a667866f74cb087de3d85"
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
