class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.21.0.tar.gz"
  sha256 "124efac2f8ee75c0fc16e1092c37b24957914d5f5de99a0e6f61d65fc3fee09d"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5eb1865c011ddcf5522585d8a2f42ec2fd05abe7e4a49b26aa0ef9e9654d44b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1939ba0329d80b88a708673f2e722517fa914905ec6e4e96bcf68b8782195663"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8884789ebccde098e87d12130ab32681301bdb889d4ca14a203d1455a1991bd2"
    sha256 cellar: :any_skip_relocation, monterey:       "7d40abc5df3fe50f68929ee53d4b6b8b8ffe9b27ba1b114f6492040be8cca21f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b937c509bfcbf1d9808a7a3294115eb2a83623793981b5379f0ec523a4535dd5"
    sha256 cellar: :any_skip_relocation, catalina:       "e290f353ec3ede9e9d4fb37edf3bb0fe7b9d36a20ebc28d68b0bb76ae23ceef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db5a7271738a939fad49565e3caafbbf4f76491d6a9fef177e2e4a5a450cafc3"
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
