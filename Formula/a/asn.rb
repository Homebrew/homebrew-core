class Asn < Formula
  desc "Organization lookup and server tool (ASN / IPv4 / IPv6 / Prefix / AS Path)"
  homepage "https://github.com/nitefood/asn"
  url "https://github.com/nitefood/asn/archive/refs/tags/v0.78.3.tar.gz"
  sha256 "3c0b15e2fb9d31e1dc2fb58822635810882b12c0b6ebeb7b98f41f1108fa0ca3"
  license "MIT"
  head "https://github.com/nitefood/asn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f9f355774478d080cd50c2bdde2a61d24bf87024e31e6c6df6408218eeda6685"
  end

  depends_on "aha"
  depends_on "bash"
  depends_on "coreutils"
  depends_on "grepcidr"
  depends_on "ipcalc"
  depends_on "jq"
  depends_on "mtr"
  depends_on "nmap"

  uses_from_macos "curl"
  uses_from_macos "whois"

  on_linux do
    depends_on "bind" # for `host`
  end

  def install
    bin.install "asn"
  end

  test do
    test_ip = "8.8.8.8"
    output = shell_output("#{bin}/asn #{test_ip} 2>&1")
    assert_match "ASN lookup for #{test_ip}", output
  end
end
