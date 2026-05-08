class IcannRdap < Formula
  desc "Full-rich client for the Registry Data Access Protocol (RDAP) sponsored by ICANN"
  homepage "https://github.com/icann/icann-rdap/wiki"
  url "https://github.com/icann/icann-rdap/archive/refs/tags/v0.0.29.tar.gz"
  sha256 "f7a717aa9d428af9e88fac770f0433bc557c82d682f0091d4e1d12a420fd428f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "966a48227c17aa3f40e31d3e28ff6b7096d0ab1a82bb38044a8532af58d7cedd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85686ffe266d1edf673dd323dbf68b357d16709f90337d077b4cc95f93bae2ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85e49646eb3a9d8331642716f6d45147479ee3bd82a6fa7765af48fd89a7802f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f26a52532a842398d923c1d41da53366fcc2e63095f9c1222517bacb4133f89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c11fdc5bcc524f07bc6f1188f66836b4ed0a577aa7f2a6c66494922c87553c76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a75453ab2eb7ba11eddfe73fec1e994c36b0d1e685aa7deb7eb8dc25af37cf41"
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
