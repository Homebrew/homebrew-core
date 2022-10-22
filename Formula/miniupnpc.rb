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
    sha256 cellar: :any,                 arm64_ventura:  "ea46ff9ec140cd8f3c96a39836c03a5a200a54d1707788453811737171aa7668"
    sha256 cellar: :any,                 arm64_monterey: "eeedebb76eb7694694f4f6e9684ebadbe79145ad8e1722a86db71f1a548fdc81"
    sha256 cellar: :any,                 arm64_big_sur:  "c3e13a0a9a9a29ae1e11b68391c05af3502a38cc8e4c64106cab777453db5027"
    sha256 cellar: :any,                 monterey:       "a82b6de740bda6e1a89fd21ef22336741a61fe718056796a850dbe75c819d84c"
    sha256 cellar: :any,                 big_sur:        "dc8464030d7e318498fbed1aa9964c925285ceb6543a09abcff42b343681b20e"
    sha256 cellar: :any,                 catalina:       "6a509044ce6d522df1c435ba211ec9cac427328bee216619f8fcd7c6de65ce0a"
    sha256 cellar: :any,                 mojave:         "03cc532eeef519bf6db64926a70d56b365eccb0e752ab791cf21683da94bddc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b4567463c162018e8c13e28a3335cfc657108cd0a6c0446f4cb28c9c54b53d1"
  end

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/upnpc --help 2>&1", 1)
    assert_match version.to_s, output
  end
end
