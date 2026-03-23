class Asn < Formula
  desc "Organization lookup and server tool (ASN / IPv4 / IPv6 / Prefix / AS Path)"
  homepage "https://github.com/nitefood/asn"
  url "https://github.com/nitefood/asn/archive/refs/tags/v0.80.4.tar.gz"
  sha256 "5e853b6e04dc8b34a785203fe1dcd146cda3ecc07099fdced193f34aec9e2081"
  license "MIT"
  head "https://github.com/nitefood/asn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "67fc0308b2ce3b8071a5c06bf49c84b83784666329b1ddf965d6fbb19323b693"
  end

  depends_on "aha"
  depends_on "coreutils"
  depends_on "grepcidr"
  depends_on "ipcalc"
  depends_on "mtr"
  depends_on "nmap"

  uses_from_macos "jq", since: :sequoia
  uses_from_macos "whois"

  on_macos do
    depends_on "bash" # Bash 4.2+
  end

  on_linux do
    depends_on "bind" # for `host`
  end

  def install
    bin.install "asn"
    man1.install "asn.1"
  end

  test do
    test_ip = "8.8.8.8"
    output = shell_output("#{bin}/asn #{test_ip} 2>&1")
    assert_match "ASN lookup for #{test_ip}", output
  end
end
