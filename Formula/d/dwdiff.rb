class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "https://os.ghalkes.nl/dwdiff.html"
  url "https://os.ghalkes.nl/dist/dwdiff-2.1.4.tar.bz2"
  sha256 "df16fec44dcb467d65a4246a43628f93741996c1773e930b90c6dde22dd58e0a"
  license "GPL-3.0-only"
  revision 6

  livecheck do
    url "https://os.ghalkes.nl/dist/"
    regex(/href=.*?dwdiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "b729110551329cd6543d14ff0834cf0ae6f2a0412e9137777406e0205de71a1b"
    sha256 arm64_ventura:  "3d18dbd0fb5990447d07b52a23538bf58a93fc4eb11d81b9b3436235473d42da"
    sha256 arm64_monterey: "48f313c0e2f18b26a5485162d5505f80ac132dbd18bcb7027cea6063a4fc34c5"
    sha256 arm64_big_sur:  "441089913eaf0ff91f63075b82840be1073448d7b338e2e20810dc91f170ed05"
    sha256 sonoma:         "98e19a8d5a87878179d323d04a584caf4d9541c6f45729d069d8080bc398ac7d"
    sha256 ventura:        "bae4837cb81fb3fc0a1b9012f28a7c1620b5f82de097124a6a3a87a58a355b59"
    sha256 monterey:       "3751aa518be8eebf901f52c496c37f7272bf2b78105e9c415ba8c29025ce360a"
    sha256 big_sur:        "5c56c5d0d13fcb82d9ca2089fbaba498a0b6e12bc5da00d87114210749e895c3"
    sha256 x86_64_linux:   "20e42b4617d19d3292fca09980c13053975d5c11f065bfe819ed6a1587749d47"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "icu4c"

  def install
    gettext = Formula["gettext"]
    icu4c = Formula["icu4c"]
    ENV.append "CFLAGS", "-I#{gettext.include} -I#{icu4c.include}"
    ENV.append "LDFLAGS", "-L#{gettext.lib} -L#{icu4c.lib}"
    ENV.append "LDFLAGS", "-lintl" if OS.mac?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # Remove non-English man pages
    (man/"nl").rmtree
    (man/"nl.UTF-8").rmtree
    (share/"locale/nl").rmtree
  end

  test do
    (testpath/"a").write "I like beers"
    (testpath/"b").write "I like formulae"
    diff = shell_output("#{bin}/dwdiff a b", 1)
    assert_equal "I like [-beers-] {+formulae+}", diff
  end
end
