class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-47.0.0.tar.xz"
  sha256 "8b7744203758025585b28200906c4b85716a6b1b95fed77cc520f9ae59c2ae44"

  bottle do
    cellar :any
    sha256 "53bf26b2e01c575b7916d183f020e7916a3fd7b353fc9fbd95a936542f677322" => :catalina
    sha256 "10edde73cba6c791782a6ce2bf9902ebcd3fbd474f513ff007eaaef81108fc48" => :mojave
  end

  head do
    url "https://gitlab.com/mbunkus/mkvtoolnix.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "pugixml" => :build
  depends_on "boost"
  depends_on "flac"
  depends_on "fmt"
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
