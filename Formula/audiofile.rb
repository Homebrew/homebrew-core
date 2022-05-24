class Audiofile < Formula
  desc "Reads and writes many common audio file formats"
  homepage "https://audiofile.68k.org/"
  license "LGPL-2.1"
  revision 1

  stable do
    url "https://audiofile.68k.org/audiofile-0.3.6.tar.gz"
    sha256 "cdc60df19ab08bfe55344395739bb08f50fc15c92da3962fac334d3bff116965"

    # Fixes CVE-2015-7747. Fixed upstream but doesn't apply cleanly.
    # https://github.com/mpruett/audiofile/commit/b62c902dd258125cac86cd2df21fc898035a43d3
    patch do
      url "https://deb.debian.org/debian/pool/main/a/audiofile/audiofile_0.3.6-5.debian.tar.xz"
      sha256 "7ae94516b5bfea75031c5bab1e9cccf6a25dd438f1eda40bb601b8ee85a07daa"
      apply "patches/03_CVE-2015-7747.patch"
    end
  end

  livecheck do
    url :homepage
    regex(/href=.*?audiofile[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "566b6a39c409fee041a5777d97f99a53b41c2cae00fc9272e9b744c778476bfa"
    sha256 cellar: :any,                 arm64_big_sur:  "7d21073f62480d59fd0c48a8b1709fec138136d158edd393b4923f18b19e5e2b"
    sha256 cellar: :any,                 monterey:       "7cc7e92e213d173164aabce6c57dc04ba4f3886a349971a923eca3492687f98b"
    sha256 cellar: :any,                 big_sur:        "c5c43335ee45d57ae38dd1a8c762f7a9e288529942b356be9a1165d886fbacb4"
    sha256 cellar: :any,                 catalina:       "86f668b5e2ddbbbb8c156a3145382431865936ba8e54469a565101e9b28de3a4"
    sha256 cellar: :any,                 mojave:         "b3f405c20f331ae6ded75f702bd68e45994c3c81eaf23abf650233859a830769"
    sha256 cellar: :any,                 high_sierra:    "daf0e362bb9e6c4fb3e6e04b0309a975d94893e5240bf394038693b9b1a2a024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcd26f7d57c2394175be368ead32f926b46f00e4424197096ddb4d5d8394dbe5"
  end

  head do
    url "https://github.com/mpruett/audiofile.git"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "alsa-lib"
  end

  resource "aiff" do
    url "http://www-mmsp.ece.mcgill.ca/Documents/AudioFormats/AIFF/Samples/CCRMA/wood24.aiff"
    sha256 "a87279e3a101162f6ab0d4f70df78594d613e16b80e6257cf19c5fc957a375f9"
  end

  # These have all been reported upstream but beside
  # 03_CVE-2015-7747 not yet merged or fixed.
  # https://github.com/mpruett/audiofile/issues/31
  # https://github.com/mpruett/audiofile/issues/32
  # https://github.com/mpruett/audiofile/issues/33
  # https://github.com/mpruett/audiofile/issues/34
  # https://github.com/mpruett/audiofile/issues/35
  # https://github.com/mpruett/audiofile/issues/36
  # https://github.com/mpruett/audiofile/issues/37
  # https://github.com/mpruett/audiofile/issues/38
  # https://github.com/mpruett/audiofile/issues/39
  # https://github.com/mpruett/audiofile/issues/40
  # https://github.com/mpruett/audiofile/issues/41
  # https://github.com/mpruett/audiofile/pull/42
  patch do
    url "https://deb.debian.org/debian/pool/main/a/audiofile/audiofile_0.3.6-5.debian.tar.xz"
    sha256 "7ae94516b5bfea75031c5bab1e9cccf6a25dd438f1eda40bb601b8ee85a07daa"
    apply "patches/04_clamp-index-values-to-fix-index-overflow-in-IMA.cpp.patch",
          "patches/05_Always-check-the-number-of-coefficients.patch",
          "patches/06_Check-for-multiplication-overflow-in-MSADPCM-decodeSam.patch",
          "patches/07_Check-for-multiplication-overflow-in-sfconvert.patch",
          "patches/08_Fix-signature-of-multiplyCheckOverflow.-It-returns-a-b.patch",
          "patches/09_Actually-fail-when-error-occurs-in-parseFormat.patch",
          "patches/10_Check-for-division-by-zero-in-BlockCodec-runPull.patch"
  end

  def install
    if build.head?
      inreplace "autogen.sh", "libtool", "glibtool"
      ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    end

    configure = build.head? ? "./autogen.sh" : "./configure"
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    system configure, *args
    system "make"
    system "make", "install"
  end

  test do
    resource("aiff").stage do
      mv "wood24.aiff", testpath/"test.aiff"
    end

    inn  = testpath/"test.aiff"
    out  = "test.wav"

    system bin/"sfconvert", inn, out, "format", "wave"
    system bin/"sfinfo", "--short", "--reporterror", out
  end
end
