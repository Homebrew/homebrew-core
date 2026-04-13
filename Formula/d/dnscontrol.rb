class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.36.1.tar.gz"
  sha256 "2584fe62ac4f6895a4780ac82c2abc3a516638d650f51f8376c801694a5c2b03"
  license "MIT"
  version_scheme 1
  head "https://github.com/StackExchange/dnscontrol.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released and they sometimes re-tag versions before that point, so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eaf40becc63e8388bd6600f623e941c0cebcd975bbf05a7a31225340cc9e1e22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b614144fb848c2b7f7524e679a55f7aa1047fdfe68fdead2f38dae53676c46f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cf56dd010a11d6ef2c3ddfdec5af0b3a9e2469fb119b8c2775d5ee271cbb3de"
    sha256 cellar: :any_skip_relocation, sonoma:        "79eb7c200c241df7343c029eca9ad442731c1d13c3851b18ce7b9201ce2cc24f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6d9c92a7a7dbdf9653952b04d6c049c649491b9882cc7aaa6e31be82b1eaa26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7075c70c51c66995d6816bc980fdc3203f7c43364d24ef2c1d7a4af28323493b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/StackExchange/dnscontrol/v4/pkg/version.version=#{version}
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
