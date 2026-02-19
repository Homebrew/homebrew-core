class Asn < Formula
  desc "Organization lookup and server tool (ASN / IPv4 / IPv6 / Prefix / AS Path)"
  homepage "https://github.com/nitefood/asn"
  url "https://github.com/nitefood/asn/archive/refs/tags/v0.80.0.tar.gz"
  sha256 "73b28d4a1f53e0bda4b72e543b41800d8af1bce7df959350b54f5b073a6e3434"
  license "MIT"
  head "https://github.com/nitefood/asn.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "284c2eaf06c2c94b578910396028e9bedd8dd1ece2b0d985903569ffe9ef6d94"
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
