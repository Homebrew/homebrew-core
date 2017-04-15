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
      url "https://mirrors.ocf.berkeley.edu/debian/pool/main/a/audiofile/audiofile_0.3.6-4.debian.tar.xz"
      mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/a/audiofile/audiofile_0.3.6-4.debian.tar.xz"
      sha256 "0620675a52bdb40b775980cc1820e308df329348bb847f9a4a8361b3799fa241"
      apply "patches/03_CVE-2015-7747.patch"
    end
  end

  bottle do
    cellar :any
    sha256 "6b450a6826130391d9cd353cc246ad9f5fa4874c5434516d3d8a681d147c5552" => :sierra
    sha256 "6fb50402d26b8122f6eb424bd0cb359a903451321f331e5a2f0fa19fc24759e2" => :el_capitan
    sha256 "0b7f9bd2023f2b52e4b3f7c03ddd822b0866874325adacfa10b582740e070cdc" => :yosemite
    sha256 "a03ebac03c59a9a65482cfa420b54f6be76bfae546ceaa1e70340ef0d02d42a7" => :mavericks
    sha256 "b68287cea599e95d784529b79a2b17fea366bc756d9a84ee8a77c06fcffda773" => :mountain_lion
  end

  head do
    url "https://github.com/mpruett/audiofile.git"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-lcov", "Enable Code Coverage support using lcov"
  option "with-test", "Run the test suite during install (~30sec)"

  deprecated_option "with-check" => "with-test"

  depends_on "lcov" => :optional

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
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/a/audiofile/audiofile_0.3.6-4.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/a/audiofile/audiofile_0.3.6-4.debian.tar.xz"
    sha256 "0620675a52bdb40b775980cc1820e308df329348bb847f9a4a8361b3799fa241"
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
    args << "--enable-coverage" if build.with? "lcov"
    system configure, *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    inn  = "/System/Library/Sounds/Glass.aiff"
    out  = "Glass.wav"

    system bin/"sfconvert", inn, out, "format", "wave"
    system bin/"sfinfo", "--short", "--reporterror", out
  end
end
