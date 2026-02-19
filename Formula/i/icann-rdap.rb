class IcannRdap < Formula
  desc "Full-rich client for the Registry Data Access Protocol (RDAP) sponsored by ICANN"
  homepage "https://github.com/icann/icann-rdap/wiki"
  url "https://github.com/icann/icann-rdap/archive/refs/tags/v0.0.26.tar.gz"
  sha256 "85150d97000e4457d1bc6b78c303bae4749a145eac5ded011e8b8af452ccb469"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95bf2f9f197774f7462cd0e3e65987fdb531533dc1baeba4677a20414514ee4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f8b5cb14c28e0834571b9744ac48de90303179c2ee482cc1489301fe15bbfd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c18799afc149073458e5be20bbe03ead3f1fb44763abb9a644036b4e34dbbc6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "019f022662393a0445c40b725dba87c1911b50f8f092ea7939f18e4a6334694b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8abc9cf84e95435d39dc80e9ef6c43381442a44aede10dad69b5067ff42d847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fe3d7f7dede8e19fd26da70ac80fafe8598114442ab7152d5ce4959675b9859"
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
