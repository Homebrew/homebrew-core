class IcannRdap < Formula
  desc "Full-rich client for the Registry Data Access Protocol (RDAP) sponsored by ICANN"
  homepage "https://github.com/icann/icann-rdap/wiki"
  url "https://github.com/icann/icann-rdap/archive/refs/tags/v0.0.30.tar.gz"
  sha256 "7dcdd36e6f36ebb8c11b6576c7ba10e314de8594adddde242c8f801ed1a3f4f4"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe7938bd1ceabe0e479069d51e5956c05a2bfe9b99af967a37cd4d24caa9ffee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "761791638f2593feb4aee4b9faf35177ee53d30863eaf66720bd025e9b86adba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "422c38bccd9c582fc1955d8d49c007870377df7c87c78d900864c2b2e636b786"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbd74ac9ffb1178cab3de813825a8f1a13b5c32ededaa3d4f0ad59926b2ff789"
    sha256 cellar: :any,                 arm64_linux:   "954b670c2ba1e0f9634cf65385d28df8d3d010c4ffe100c40335c8405473c177"
    sha256 cellar: :any,                 x86_64_linux:  "aa581b2c93543577f03c1b432b35bc7b3812e83fe85df6de2d98ba6e9c64779d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  conflicts_with "rdap", because: "rdap also ships a rdap binary"

  def install
    system "cargo", "install", "--bin=rdap", *std_cargo_args(path: "icann-rdap-cli")
    system "cargo", "install", "--bin=rdap-test", *std_cargo_args(path: "icann-rdap-cli")
  end

  test do
    mkdir ".config"
    assert_match "icann-rdap-cli #{version}", shell_output("#{bin}/rdap -V")
    assert_match "icann-rdap-cli #{version}", shell_output("#{bin}/rdap-test -V")

    # lookup com TLD at IANA with rdap
    url = "https://rdap.iana.org/domain/com"
    output = shell_output("#{bin}/rdap -O pretty-json #{url}")
    assert_match '"ldhName": "com"', output

    # test com TLD at IANA with rdap-test
    output = shell_output("#{bin}/rdap-test -O pretty-json --skip-v6 -C gtld-profile-error #{url}")
    assert_match '"status_code": 200', output
  end
end
