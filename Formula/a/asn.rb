class Asn < Formula
  desc "Organization lookup and server tool (ASN / IPv4 / IPv6 / Prefix / AS Path)"
  homepage "https://github.com/nitefood/asn"
  url "https://github.com/nitefood/asn/archive/refs/tags/v0.77.0.tar.gz"
  sha256 "c4d38393557602d7c43d04b4db7894919e9e2997cd9fb04e7959490bd5cb774e"
  license "MIT"
  head "https://github.com/nitefood/asn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c1a396fa685821955254033fffbb501cb9ab17f2bbd7cb31bf3eaf5f368f499"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c1a396fa685821955254033fffbb501cb9ab17f2bbd7cb31bf3eaf5f368f499"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c1a396fa685821955254033fffbb501cb9ab17f2bbd7cb31bf3eaf5f368f499"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c1a396fa685821955254033fffbb501cb9ab17f2bbd7cb31bf3eaf5f368f499"
    sha256 cellar: :any_skip_relocation, ventura:        "6c1a396fa685821955254033fffbb501cb9ab17f2bbd7cb31bf3eaf5f368f499"
    sha256 cellar: :any_skip_relocation, monterey:       "6c1a396fa685821955254033fffbb501cb9ab17f2bbd7cb31bf3eaf5f368f499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8ffd7227239b3e63a8eee536055030b23fe0642c2aa44b82aff6cb9568a2bef"
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
