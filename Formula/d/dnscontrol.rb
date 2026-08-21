class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/DNSControl/dnscontrol/archive/refs/tags/v4.46.0.tar.gz"
  sha256 "8267bb9285291b06efa1d1aab872acb139e93d5a8186baac3e725847c6275250"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2698880b0c7c0c42281b70b0fbcbce19a85020fdbd83e8d763494a3af1a6e8a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d59bc88bdfe776f9d3321a0d0b9268b143049f4a02be4ec48e474a4c0662e31e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b6b48ec888697959f8b391049778d052e543ce39b460cc4b7499dbaa7b3b4f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "005db8d944b304de4dfce86232588a273b34258f0703cd5fe3ffbf7a3fd18794"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b21258da0df2f6795adbc6f0cb0bdb21c80c6a6412b38568198845d7d60c55fc"
    sha256 cellar: :any,                 x86_64_linux:  "4e6c3ff611bb1a0f1d6c336ac2d5cfe77a69e7454d8e7d8b3ac6aff5b6685106"
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
