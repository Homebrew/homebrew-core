class Dnscontrol < Formula
  desc "Synchronize your DNS to multiple providers from a simple DSL"
  homepage "https://dnscontrol.org/"
  url "https://github.com/StackExchange/dnscontrol/archive/v4.3.0.tar.gz"
  sha256 "bd095638b67a3cd445b7e0fbfb50f8c5f7080087381ac4bdc349ebf489e0003a"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14a09bf5ed3c60154a1d6aeebf17c73ebea6385fc2555bbf276a593abf55f7a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3027e9c1bae099776ca9b85b381c254b5727aca595b4051c306522ce24bf3c00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0399450ce2d7de00873aa17ae73e47ee857f61c202630eebd9fc5e79b735317"
    sha256 cellar: :any_skip_relocation, ventura:        "2c02dd195baf9dfab83adad2b7c6e099a73b0a94583937b83edf5d9c2c7755c5"
    sha256 cellar: :any_skip_relocation, monterey:       "1aaa4d9a68044087314db3d6318898c26bd6b2ae4f75859ebfc242e9713c7a65"
    sha256 cellar: :any_skip_relocation, big_sur:        "82ec302f7b1c2051ad3286f6aec862d8feb58d1f4f1cee8a44762c7b907e9c1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62df16681c86ebb5c92ce40e9d168f5f7f231ea568572471f7d340b7350cca41"
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
