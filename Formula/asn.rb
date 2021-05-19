class Asn < Formula
  desc "Organization lookup and server tool (ASN / IPv4 / IPv6 / Prefix / AS Path)"
  homepage "https://github.com/nitefood/asn"
  url "https://raw.githubusercontent.com/nitefood/asn/64e92533f57e9261d1d6588b4714a4183fc3c304/asn"
  version "0.71.6"
  sha256 "277765b43a44ccf53df5d60437f7564f003d86d9c4e32e98b9eb0c8b409cf02e"
  license "MIT"

  livecheck do
    skip "Cannot reliably check for new releases upstream"
  end

  bottle :unneeded

  def install
    bin.install "asn"
  end

  test do
    assert_match version.to_s, shell_output(%Q|sed -n 's/^ASN_VERSION="\\(.*\\)"$/\\1/p' #{bin}/asn|)
  end
end
