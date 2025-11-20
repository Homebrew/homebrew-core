class IcannRdap < Formula
  desc "Full-rich client for the Registry Data Access Protocol (RDAP) sponsored by ICANN"
  homepage "https://github.com/icann/icann-rdap/wiki"
  url "https://github.com/icann/icann-rdap/archive/refs/tags/v0.0.25.tar.gz"
  sha256 "c8747f0c5a1bbc475018b76046db9c40b85018b239f2a9ba8b1fcdca295eef68"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "917cb145480db75a1992c571944be29e57f951a8050c1894faa792613034796c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c479ca72549b0609dab718bfc64214beed535e1dcfa11eb57541d5f2d2f6a3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6670b772f956ed2316b47b3aeb77dd855faec20b5f258f1bdf1b32fc1db5b31e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc6e3d18480bd354b98308321dd0a1c36ecc966d813900e2e0b931e2c8a7ecac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2535bad32b4fb9021ef3e046b689b77c0332c851080d8d366d566a6df49e04d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "853adf7af596d1950c55b66a654c1bedf11cc4e042d1e18afde41fe684190020"
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
