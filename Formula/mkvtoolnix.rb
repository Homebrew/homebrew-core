class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://www.bunkus.org/videotools/mkvtoolnix/"
  url "https://www.bunkus.org/videotools/mkvtoolnix/sources/mkvtoolnix-9.4.0.tar.xz"
  sha256 "af633768ac3ca193070c76c93bbf496b41e451d1652e1d3d6fd4c20361e56265"

  bottle do
    sha256 "94ab95d5b4a38129a76118494b6092b0ceba5af9af6b9b66fc5bc93b1d3137ab" => :el_capitan
    sha256 "763886c44ab0935eebcbe1ba98527a8fe530112f35572472f16ec032bda166c8" => :yosemite
    sha256 "38049cf7dc99e9a551c41a4150cbc13149ce4108bd05138f8666c5fe00e0ec60" => :mavericks
  end

  head do
    url "https://github.com/mbunkus/mkvtoolnix.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "with-qt5", "Build with QT GUI"

  depends_on "pkg-config" => :build
  depends_on :ruby => ["1.9", :build]
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "flac" => :recommended
  depends_on "libmagic" => :recommended
  depends_on "qt5" => :optional
  depends_on "gettext" => :optional

  # On Mavericks, the bottle (without c++11) can be used
  # because mkvtoolnix is linked against libc++ by default
  if MacOS.version >= "10.9"
    depends_on "boost"
    depends_on "libmatroska"
    depends_on "libebml"
  else
    depends_on "boost" => "c++11"
    depends_on "libmatroska" => "c++11"
    depends_on "libebml" => "c++11"
  end

  needs :cxx11

  def install
    ENV.cxx11

    boost = Formula["boost"]
    ogg = Formula["libogg"]
    vorbis = Formula["libvorbis"]
    ebml = Formula["libebml"]
    matroska = Formula["libmatroska"]

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --without-curl
      --with-boost=#{boost.opt_prefix}
      --with-extra-includes=#{ogg.opt_include};#{vorbis.opt_include};#{ebml.opt_include};#{matroska.opt_include}
      --with-extra-libs=#{ogg.opt_lib};#{vorbis.opt_lib};#{ebml.opt_lib};#{matroska.opt_lib}
    ]

    if build.with?("qt5")
      qt5 = Formula["qt5"]

      args << "--with-moc=#{qt5.opt_bin}/moc"
      args << "--with-uic=#{qt5.opt_bin}/uic"
      args << "--with-rcc=#{qt5.opt_bin}/rcc"
      args << "--enable-qt"
    else
      args << "--disable-qt"
    end

    args << "--without-flac" if build.without? "flac"
    args << "--disable-magic" if build.without? "libmagic"

    system "./autogen.sh" if build.head?

    system "./configure", *args

    system "./drake", "-j#{ENV.make_jobs}"
    system "./drake", "install"
  end

  test do
    mkv_path = testpath/"Great.Movie.mkv"
    sub_path = testpath/"subtitles.srt"
    sub_path.write <<-EOS.undent
      1
      00:00:10,500 --> 00:00:13,000
      Homebrew
    EOS

    system "#{bin}/mkvmerge", "-o", mkv_path, sub_path
    system "#{bin}/mkvinfo", mkv_path
    system "#{bin}/mkvextract", "tracks", mkv_path, "0:#{sub_path}"
  end
end
