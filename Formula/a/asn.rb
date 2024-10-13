class Asn < Formula
  desc "Organization lookup and server tool (ASN / IPv4 / IPv6 / Prefix / AS Path)"
  homepage "https://github.com/nitefood/asn"
  url "https://github.com/nitefood/asn/archive/refs/tags/v0.78.0.tar.gz"
  sha256 "048b07e370cccc6027071cf586c52a7f9ddfdd30b489eacd7e09bd6acba1dfe1"
  license "MIT"
  head "https://github.com/nitefood/asn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5993b8d07d5aa4a3b654a85b6205006c6d7cff292ab5f8b38ae959902fc364bb"
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
