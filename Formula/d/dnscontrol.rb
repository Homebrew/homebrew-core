class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.8.2.tar.gz"
  sha256 "a555135b8b8a0f61c95d8f49fafdc49b20dee1ef9b0a4849b2afea94e8b101a5"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c14528582961c5bea76c54d9f0f62ffd5b51fcf55916c18f70f9978c16173f90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4de736f96cda0af9a98650c1176210df87f11a993868411783f6bf194d676b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1203c9aa6e86f71dba37543e361a9424d4f8f74f1b38c2ae351571999dcd05ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9387af00195298ae47c014eda2a134e43786c40357cdb42e06f77e2aa0625bc"
    sha256 cellar: :any_skip_relocation, ventura:        "0d37133dc0c3831db97270a3014308bb0c381e21ec6e42b32e86825d82e0cd25"
    sha256 cellar: :any_skip_relocation, monterey:       "8ab4f3ee53024db7d14fc002db89a34d49bd13788addf3e93bc59f27332f1319"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18ecf7421b78dbb4856982ff2db260b132317b4063ee0e179a1b6a9f1ea5268c"
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
