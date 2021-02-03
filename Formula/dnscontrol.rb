class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.6.0.tar.gz"
  sha256 "5d0b0cfde6ad507f7ccbb3182c142349212759754ea6905afcf13cfcdf5f44a8"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5e0a079bf5792d0576ff1ad70dc9ca122926412a6e7e0b63b566dd07c9b465dd"
    sha256 cellar: :any_skip_relocation, big_sur:       "7fd1e0ee9361d1a706f0275da4bab52515b115d7e2b6bacbd210261131ee5ac1"
    sha256 cellar: :any_skip_relocation, catalina:      "accf9103d7b94eb7da14b1c898eba8d497c1ecd2f82eab510cd7a8dcd12290d8"
    sha256 cellar: :any_skip_relocation, mojave:        "c41532205ccef4872c37795c1f80a0454bd421daec4b40e496b72989b272febd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
    prefix.install_metafiles
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
