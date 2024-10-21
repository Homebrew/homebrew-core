class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/refs/tags/v4.14.0.tar.gz"
  sha256 "36495855ac23a927e92732a5ab2c982447d5fed8e4f963489c798564a443d6fa"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8fb7bd73177fde360f4091a3dc8ba8153b9345e04d93dc3b83410f6a2e312cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8fb7bd73177fde360f4091a3dc8ba8153b9345e04d93dc3b83410f6a2e312cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8fb7bd73177fde360f4091a3dc8ba8153b9345e04d93dc3b83410f6a2e312cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6c058c11bdf6da5edfb2f46cf3fa8673be7bbc0dedfb810312da3e33e9364b7"
    sha256 cellar: :any_skip_relocation, ventura:       "b6c058c11bdf6da5edfb2f46cf3fa8673be7bbc0dedfb810312da3e33e9364b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c737b26fad739ae78ad19c1799f632ac9303390924425377c1128045e75faf3"
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
