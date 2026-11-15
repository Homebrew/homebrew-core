class IcannRdap < Formula
  desc "Full-rich client for the Registry Data Access Protocol (RDAP) sponsored by ICANN"
  homepage "https://github.com/icann/icann-rdap/wiki"
  url "https://github.com/icann/icann-rdap/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "cde23e68f4a80216187f80a658f583adc68ee3d81776bded7abe116b1198ea9f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e86c09a0ee1f9e0cbfa5d102d753eb77d122c94a2a0e0c369ac9acd45cc33992"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "174b969a8cec708cb4ee784fb02385c21da87f20d8f687d7ef357f8e40e21a61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "321ebbbb76a2329406a9b1ceef92eea3d18228f6c629052db1c9e6c46aaa13ca"
    sha256 cellar: :any,                 arm64_linux:       "d5839496936b1e1defbf3c17000b2190851a192819de32b1bced12c68115454c"
    sha256 cellar: :any,                 x86_64_linux:      "8a985b37acdb0df46b4351d81313c0548fe83a04d7e9ec8af5b1fc7824ca4f80"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  conflicts_with "rdap", because: "rdap also ships a rdap binary"

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
