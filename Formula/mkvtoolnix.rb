class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://www.bunkus.org/videotools/mkvtoolnix/"
  url "https://www.bunkus.org/videotools/mkvtoolnix/sources/mkvtoolnix-9.3.1.tar.xz"
  sha256 "f3695761bf0a5fdcd6144cfb0a624094c10c9d66d43a340ebb917b7c6a8b39a2"
  revision 1

  bottle do
    sha256 "fcd6de3848574a16b8c5e6b0ab242b71069b3ab6ee8933779dc2374b2fc4bc78" => :el_capitan
    sha256 "cdc987d0bff9db70d08a7bef44e0ed60fbe1f706f71e976e0cdd20ef71a243b0" => :yosemite
    sha256 "970d80a3f613bb0f2c380fdc3ab0748074eb0f3c908aaa2c1128f93d31c2b25c" => :mavericks
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
  depends_on "lzo" => :optional
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
