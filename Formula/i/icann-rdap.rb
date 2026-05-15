class IcannRdap < Formula
  desc "Full-rich client for the Registry Data Access Protocol (RDAP) sponsored by ICANN"
  homepage "https://github.com/icann/icann-rdap/wiki"
  url "https://github.com/icann/icann-rdap/archive/refs/tags/v0.0.29.tar.gz"
  sha256 "f7a717aa9d428af9e88fac770f0433bc557c82d682f0091d4e1d12a420fd428f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b992d8bbbc8664e39e3dd93debb5cc90a948e390666ec3b6cac3323ce1b1e66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52d746280f938117e8af6c4863409516c5e0fe759fd27a1549d1fce4c28f3884"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f16e5b9e5163bece9f19309597ecc2cc6c7c073505236f97d8fdfcb013271dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "2567415f6046ac8b5f0dc038007584733c0218a79403002a750653909890a5cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9932b6b8e14183790413d28f81e8cbb92e558cfc60a1b89dcd6cc263884535e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cd072fe1c3c257531c58384936073c01c0fae6d3da6cde3a4203c99275dfbd1"
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
