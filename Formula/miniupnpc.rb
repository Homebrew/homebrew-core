class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.2.4.tar.gz"
  sha256 "481a5e4aede64e9ef29895b218836c3608d973e77a35b4f228ab1f3629412c4b"
  license "BSD-3-Clause"

  # We only match versions with only a major/minor since versions like 2.1 are
  # stable and versions like 2.1.20191224 are unstable/development releases.
  livecheck do
    url "https://miniupnp.tuxfamily.org/files/"
    regex(/href=.*?miniupnpc[._-]v?(\d+\.\d+(?>.\d{1,7})*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e01ae8c24a471bbb88a1033b67e041e8f9fca6634d01f92a4694db20d4d53c14"
    sha256 cellar: :any,                 arm64_monterey: "6181bbf0ea573d2f09d125c6271412502605f6a0c9e64b006cde35f048cc69f8"
    sha256 cellar: :any,                 arm64_big_sur:  "c3b527cd69eaba31f8b87f36f8a85c0c13a3c9bb19989abeba8ceefd78b9044c"
    sha256 cellar: :any,                 ventura:        "b1cb1853a2a3ff1772d70022e1e8d6a420735459fad3e1d26396df562fdfff3b"
    sha256 cellar: :any,                 monterey:       "92ec5cfb40d1da0fd842bfd2ec32ee3f5970776da4a2334aefce69463600828c"
    sha256 cellar: :any,                 big_sur:        "5d2661c359f7d7734eeedd7905038cd1e86d2b41df2aa81ca5e5ccdf55445566"
    sha256 cellar: :any,                 catalina:       "06f208877ac3279b5a9960846e27df4d8d0452a0e4d500f20ce7e01305f0e5c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93154d49e70a5e1f1a3ff6f481432e7acd9e7dd352f7c2ea78e7ca2f27b7352f"
  end

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/upnpc --help 2>&1", 1)
    assert_match version.to_s, output
  end
end
