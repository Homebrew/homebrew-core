class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-43.0.0.tar.xz"
  sha256 "5acfda67817c17702c35e14c2acd78340f608d154842a791ea17fd38835910b6"

  bottle do
    cellar :any
    sha256 "09e5dff1545f5d9180a460ffc008ce2c81b54bb09a35c01f251fe7a210d976f5" => :catalina
    sha256 "264d111e6877d5afe49f410a9473d1fb792145bbc6892f8c429f594a43eb2c7c" => :mojave
    sha256 "b6d36bf12a372847b73e7e4dd1f1ca80924f5cbd4629a3143ed3de9f264e1a70" => :high_sierra
  end

  head do
    url "https://gitlab.com/mbunkus/mkvtoolnix.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "docbook-xsl" => :build
  depends_on "fmt" => :build
  depends_on "pkg-config" => :build
  depends_on "pugixml" => :build
  depends_on "boost"
  depends_on "flac"
  depends_on "gettext"
  depends_on "libebml"
  depends_on "libmagic"
  depends_on "libmatroska"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on :macos => :mojave # C++17

  uses_from_macos "libxslt" => :build
  uses_from_macos "ruby" => :build

  def install
    ENV.cxx11

    features = %w[flac libebml libmagic libmatroska libogg libvorbis]
    extra_includes = ""
    extra_libs = ""
    features.each do |feature|
      extra_includes << "#{Formula[feature].opt_include};"
      extra_libs << "#{Formula[feature].opt_lib};"
    end
    extra_includes.chop!
    extra_libs.chop!

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          "--with-docbook-xsl-root=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl",
                          "--with-extra-includes=#{extra_includes}",
                          "--with-extra-libs=#{extra_libs}",
                          "--disable-qt"
    system "rake", "-j#{ENV.make_jobs}"
    system "rake", "install"
  end

  test do
    mkv_path = testpath/"Great.Movie.mkv"
    sub_path = testpath/"subtitles.srt"
    sub_path.write <<~EOS
      1
      00:00:10,500 --> 00:00:13,000
      Homebrew
    EOS

    system "#{bin}/mkvmerge", "-o", mkv_path, sub_path
    system "#{bin}/mkvinfo", mkv_path
    system "#{bin}/mkvextract", "tracks", mkv_path, "0:#{sub_path}"
  end
end
