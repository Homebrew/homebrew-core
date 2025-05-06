class IcannRdap < Formula
  desc "Full-rich client for the Registry Data Access Protocol (RDAP) sponsored by ICANN"
  homepage "https://github.com/icann/icann-rdap/wiki"
  url "https://github.com/icann/icann-rdap/archive/refs/tags/v0.0.22.tar.gz"
  sha256 "42360a82605bf92891b4de0a133d43baabb041446b16063094c4abc94c531c30"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70a951b05788925c050650eaec31c3a7a0e26869d77701b190dfba2787a1d063"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "812554fed56276e8cf3e84147630a91f60a08a1c5a0b1f48802e4e35780f5e7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4f9f9c8d870740f0e2dbe9b89799fbb9c6e652eab49ee30828501dee2c86892"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c636a8333f3f570b08255835a91e4801d02c1f63790068bcb30e1c749a48f39"
    sha256 cellar: :any_skip_relocation, ventura:       "fd38c0e06394376548163d27eec245846b5486cf6778ff08a7310e41f30d2970"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0c436e4857f837be3315250b81ae04f1971a07fc13b5eb2d0a6ac6bce427191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76d31f3744546c6f91b20c85bf371e1a3cf89eb0eef808c61fbef8e449302f4c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  conflicts_with "rdap", because: "rdap also ships a rdap binary"

  def install
    system "cargo", "install", "--bin=rdap", *std_cargo_args(path: "icann-rdap-cli")
    system "cargo", "install", "--bin=rdap-test", *std_cargo_args(path: "icann-rdap-cli")
  end

  test do
    # check version of rdap
    assert_match "icann-rdap-cli #{version}", shell_output("#{bin}/rdap -V")

    # check version of rdap-test
    assert_match "icann-rdap-cli #{version}", shell_output("#{bin}/rdap-test -V")

    # lookup com TLD at IANA with rdap
    output = shell_output("#{bin}/rdap -O pretty-json https://rdap.iana.org/domain/com")
    assert_match '"ldhName": "com"', output

    # test com TLD at IANA with rdap-test
    output = shell_output("#{bin}/rdap-test -O pretty-json --skip-v6 -C icann-error https://rdap.iana.org/domain/com")
    assert_match '"status_code": 200', output
  end
end
