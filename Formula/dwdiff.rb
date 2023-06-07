class Dwdiff < Formula
  desc "Diff that operates at the word level"
  homepage "https://os.ghalkes.nl/dwdiff.html"
  url "https://os.ghalkes.nl/dist/dwdiff-2.1.4.tar.bz2"
  sha256 "df16fec44dcb467d65a4246a43628f93741996c1773e930b90c6dde22dd58e0a"
  license "GPL-3.0-only"
  revision 5

  livecheck do
    url "https://os.ghalkes.nl/dist/"
    regex(/href=.*?dwdiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "c7403a1549b8fa70d558809efd0e3b017821509b6cf5b0aa1fa43a86171fad61"
    sha256 arm64_monterey: "6392b4e1efde2fcb00a1200fcba8bfa3201fa1a5d745dbea12d4941dec23b769"
    sha256 arm64_big_sur:  "718f193ea32b2c276d7a31be0246fa4abcb1e38e729106adc777c6703ebcd3bc"
    sha256 ventura:        "da639a99d1c2163de1c873fd2b3b1ee3c4e782f929fa20cffbee1f8fd4c47f1f"
    sha256 monterey:       "1e8b74e1e521833f7abd3891d3a006964e431fe21afc81d56c0a36e61741aeb0"
    sha256 big_sur:        "6e615cbd5b95a8073c6ffdb0e346eeac1d2ebb7d1bb369976eda9c16214a2586"
    sha256 x86_64_linux:   "df6c973cb7fa6a7780de57c0517faf514e51315908639438c90cdc000d46ee37"
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
