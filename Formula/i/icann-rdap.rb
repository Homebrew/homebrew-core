class IcannRdap < Formula
  desc "Full-rich client for the Registry Data Access Protocol (RDAP) sponsored by ICANN"
  homepage "https://github.com/icann/icann-rdap/wiki"
  url "https://github.com/icann/icann-rdap/archive/refs/tags/v0.0.21.tar.gz"
  sha256 "252b112776fae0160f539e20b70ff24b6f2bea7551c9476ccd6f7651c7b861d0"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90dd2871061dbb621157244693df3d361072e015af84f8ab2ab3b48851889fd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "425f54cbcfd6d997c1112e5a12ed9bfd23932c1c339dd95d7f1d515f4a925349"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb5fd0c882692fbc37f38f26ff38a4e365eee66a9da130a1c21b9c3d0a1af2b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dddb2b0fbb213392014322889534b08e38d4ca24ffb0996d15bdec21abcb1d3"
    sha256 cellar: :any_skip_relocation, ventura:       "d132e511cc94753fbf2c719f9b81f8944bd7470c52088dd0b45725245083dfe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62401230680ed85dfccb10042c702f1711865443efe6e4bfde6c52898203b643"
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
