class Audiofile < Formula
  desc "Reads and writes many common audio file formats"
  homepage "https://audiofile.68k.org/"
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

  bottle do
    cellar :any
    rebuild 1
    sha256 "86f668b5e2ddbbbb8c156a3145382431865936ba8e54469a565101e9b28de3a4" => :catalina
    sha256 "b3f405c20f331ae6ded75f702bd68e45994c3c81eaf23abf650233859a830769" => :mojave
    sha256 "daf0e362bb9e6c4fb3e6e04b0309a975d94893e5240bf394038693b9b1a2a024" => :high_sierra
  end

  head do
    url "https://github.com/mpruett/audiofile.git"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
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
    inn  = "/System/Library/Sounds/Glass.aiff"
    out  = "Glass.wav"

    system bin/"sfconvert", inn, out, "format", "wave"
    system bin/"sfinfo", "--short", "--reporterror", out
  end
end
