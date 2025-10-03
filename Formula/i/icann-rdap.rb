class IcannRdap < Formula
  desc "Full-rich client for the Registry Data Access Protocol (RDAP) sponsored by ICANN"
  homepage "https://github.com/icann/icann-rdap/wiki"
  url "https://github.com/icann/icann-rdap/archive/refs/tags/v0.0.23.tar.gz"
  sha256 "4ae3ff5943d18de353a18578e64e4bd8693b4a6553c2b7cdaf8c4b9acedb7f6f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "352c452c9ef665ece711bb01342c3781390aa320ac702dfac00b2a75ed1183e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70d38d4a8ce06f1bacf93ab7c78f8a6e4b1318f356539b0d4a2539d1921929dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "065c8f593a079ecca9cbeb45163050491d575e74b37f2249ff4f73a335084b9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1adb9b61c87c0e045373478be8254687a2685426553c073cad41cc7f3d890004"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2171420d6014d56eada10247a93948da4fe9152c0e2cf3801decaa0d18d444f"
    sha256 cellar: :any_skip_relocation, ventura:       "c3464c0ee338bca517d7b7dcdaa2969f193865b7c86d127c8d84e203141b88db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79f8122c74ae08ab127e1cda739fbdafb783093db48c5b704911f60255eef7cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75bd95d6e2eb1d50bf4c518844c813af17bd2fbabc7ba5c546a8d7089d2ed210"
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
