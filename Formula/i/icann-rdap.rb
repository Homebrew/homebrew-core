class IcannRdap < Formula
  desc "Full-rich client for the Registry Data Access Protocol (RDAP) sponsored by ICANN"
  homepage "https://github.com/icann/icann-rdap/wiki"
  url "https://github.com/icann/icann-rdap/archive/refs/tags/v0.0.31.tar.gz"
  sha256 "b40724c334b789dd80d5b12331753c940f244d677f903e4667c10d8038527c49"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14e840077257a08bc5fe4de220c1072a0e159a0ad5f645506a892b0c46062ae4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6deb4027ee33a57426ce8b53b9eb32cde35d6f219ba003742a993b97ab0ff923"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ac58555aebad0729ba9ed60e5c334a7404c4b1cb7b7d679e5da5a5ebad5d385"
    sha256 cellar: :any_skip_relocation, sonoma:        "9898be7db80ec5e57c18942432c7761516721982a72412c532302156793d62f0"
    sha256 cellar: :any,                 arm64_linux:   "eaad9cc0f9e97b22af0b5bebdda7ef291a6159fdbc9d5057d8246d289146fed2"
    sha256 cellar: :any,                 x86_64_linux:  "d1f4b50cd7ff5dde56133fc034ef0a50714104be3220766b41f53d850c2b7dbd"
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
