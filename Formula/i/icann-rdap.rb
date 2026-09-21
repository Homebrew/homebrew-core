class IcannRdap < Formula
  desc "Full-rich client for the Registry Data Access Protocol (RDAP) sponsored by ICANN"
  homepage "https://github.com/icann/icann-rdap/wiki"
  url "https://github.com/icann/icann-rdap/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "6103c53142b20f55b6868793c29e13bda15852eda24cb50444b812ed4a3a967b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8d89ef2c5581b9f2e5f9da95a428590d7cb4e93aa97b5261393cc903ce029af1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3f1d1814176217bac06e3d8989238de805e3f7c92a758b4df2505a1265ced0d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0ae6480eeb3f0f2e9ec3f0d0896691d738e7d32eb725d66747d26ee630d45d5d"
    sha256 cellar: :any,                 arm64_linux:       "bdb7a6219cdcd52bac441c7f7afab63e3a0a2806b798410f3884f0fc51bb3526"
    sha256 cellar: :any,                 x86_64_linux:      "353048a48579151d1649fb9d05a6481804f4dee5873020a52c281f067c3dec62"
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
