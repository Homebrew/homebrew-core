class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://www.bunkus.org/videotools/mkvtoolnix/"
  url "https://www.bunkus.org/videotools/mkvtoolnix/sources/mkvtoolnix-9.9.0.tar.xz"
  sha256 "f06c9359bd197b5de6556a05506f0ea9ddab72045b72f1ed04b1807e4e042043"

  bottle do
    sha256 "0b4cfaf7c807502a0edb45c3b828dff19947e9bd50f086eed3f90295f277b9fc" => :sierra
    sha256 "7016a9a6e75fc4e91404f177a2504d9437acf292993a68cb702f22ce3e8a4587" => :el_capitan
    sha256 "b93feeaf8df6b4d780993509511d9edebb40b7113332811bb9f4cc0cbc800f05" => :yosemite
  end

  head do
    url "https://github.com/mbunkus/mkvtoolnix.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "with-qt5", "Build with QT GUI"

  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "pugixml" => :build
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

    features = %w[libogg libvorbis libebml libmatroska]
    features << "flac" if build.with? "flac"
    features << "libmagic" if build.with? "libmagic"

    extra_includes = ""
    extra_libs = ""
    features.each do |feature|
      extra_includes << "#{Formula[feature].opt_include};"
      extra_libs << "#{Formula[feature].opt_lib};"
    end
    extra_includes.chop!
    extra_libs.chop!

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-docbook-xsl-root=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl
      --with-extra-includes=#{extra_includes}
      --with-extra-libs=#{extra_libs}
    ]

    if build.with? "qt5"
      args << "--with-moc=#{Formula["qt5"].opt_bin}/moc"
      args << "--with-rcc=#{Formula["qt5"].opt_bin}/rcc"
      args << "--with-uic=#{Formula["qt5"].opt_bin}/uic"
      args << "--enable-qt"
    else
      args << "--disable-qt"
    end

    system "./autogen.sh" if build.head?

    system "./configure", *args

    system "rake", "-j#{ENV.make_jobs}"
    system "rake", "install"
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
