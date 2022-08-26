class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.20.0.tar.gz"
  sha256 "6aa164f2b3f8a07c0460bb0f75517b202c26d3c17d05a7f0a6073cfdaa0eba0c"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "187e3e6e1fd953b1a36f452c8939829bf924815cdff8d6a6e05924713dc38b93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abd2fd5a1e50f064a251db9c7b00076d08d79be0d21f1ca9e76502649725a467"
    sha256 cellar: :any_skip_relocation, monterey:       "0ffdc04fae277d43f418afe1caef56117ec27ae914bf4b94b7b71ee5c36c1176"
    sha256 cellar: :any_skip_relocation, big_sur:        "6996d0c53c67fffeb7df9dd67658e3e9ce54c87c86216cf6ad41a50978b5c331"
    sha256 cellar: :any_skip_relocation, catalina:       "cfa066d29db2b3562f0d216d95d6a50310210e3f0727f98d30c3c8491bbfb89e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3aa7d1862f9f8e061351c0586c3886e4de464946f9debe9893c3d5920aabd7ef"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
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
