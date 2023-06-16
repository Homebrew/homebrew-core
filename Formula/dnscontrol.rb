class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/v4.1.1.tar.gz"
  sha256 "8617afe9af8fd40ee2ddcf8ebc6464290a5a5fff0e5b5723e4e0f55b7604065e"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "480ed963bcd201fe04fff3bb87ccb605070f59bcadae10d9cd8e224fcffa4211"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "480ed963bcd201fe04fff3bb87ccb605070f59bcadae10d9cd8e224fcffa4211"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "480ed963bcd201fe04fff3bb87ccb605070f59bcadae10d9cd8e224fcffa4211"
    sha256 cellar: :any_skip_relocation, ventura:        "a7575d6939f3857c49a4ac7fb89e7757f02d1f798e62627e4457ef47224f032e"
    sha256 cellar: :any_skip_relocation, monterey:       "a7575d6939f3857c49a4ac7fb89e7757f02d1f798e62627e4457ef47224f032e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7575d6939f3857c49a4ac7fb89e7757f02d1f798e62627e4457ef47224f032e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "489175ff34ac402f94a59c63c1f7e2521c4013e035f4c1b567f13508f9475097"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.SHA=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dnscontrol version")
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
