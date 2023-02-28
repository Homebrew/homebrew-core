class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.27.1.tar.gz"
  sha256 "bf81660ebd7ef14501e2fbd715af67f2c51f182d17b9b6014bd05b79577d56b3"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae97559731951488a91136bc728e22d795072b492d72dfb8fcffe09384927de0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "458ea64a93a4c9d178a28efc0ea8e3931c91bc09d196e752a3497da4aafe6c55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe8e7dbbebd31b1d39506ea413a5a41e1b6160559ca350f8a0653697159925e0"
    sha256 cellar: :any_skip_relocation, ventura:        "ba2c1261527d301d743945b24ab04f7a67958fcc5ed1b270dab76986269c6599"
    sha256 cellar: :any_skip_relocation, monterey:       "fde6923310694ef7b56d992301922c6945d9c3d2d759e95347a9629df363d01f"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf6b2d56cf17ce86c88ad0fa059a6f2a44b52609fc928914ec79770879d9b944"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1a5251242ea7c4c2a317ba130dabda7793dc0fdb8319fd6b5db2c26029d0c95"
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
