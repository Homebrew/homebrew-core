class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.13.0.tar.gz"
  sha256 "5bce728448666a05175c8c5ecb7d33f13ab1a4d38d8ea251165d78e0133ce0ec"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "87dac3ced43d131d8b2aa6e1edc6ca74c46dbae1bebbd1ccfc6490f89e42051c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "541405680d7c2d82245756c5cdb277bf0adcf406dcc126474cd16dd82931fb38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "541405680d7c2d82245756c5cdb277bf0adcf406dcc126474cd16dd82931fb38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "541405680d7c2d82245756c5cdb277bf0adcf406dcc126474cd16dd82931fb38"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd26db7181c11946153f4928ae579489e04c2d838b0e9395123bd770d79ec5f9"
    sha256 cellar: :any_skip_relocation, ventura:        "cd26db7181c11946153f4928ae579489e04c2d838b0e9395123bd770d79ec5f9"
    sha256 cellar: :any_skip_relocation, monterey:       "cd26db7181c11946153f4928ae579489e04c2d838b0e9395123bd770d79ec5f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fd903ed1a05ef2e91e9960a5a121a16ca8b3b96eff287b226dcc37170a7b3e0"
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
