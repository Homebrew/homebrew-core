class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-77.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-77.0.tar.xz"
  sha256 "5f0cb2b7afe39226d0d41bd7ba098db669981da8c4b455862faffae04ca8e57a"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "01486cd9c9b97501aefba2a35c28da6e1b7add3897e4c6b0be74e230d4abffdf"
    sha256 cellar: :any, arm64_monterey: "541fb9f14e48f1f376f712f59f7fb5aa7da56aefc9b35b4cf43443322f7f0d28"
    sha256 cellar: :any, arm64_big_sur:  "745151fc8de978f47af579a8dbd8d69c8ee28411a7b63980bf570350032eb722"
    sha256 cellar: :any, ventura:        "ef71d0c6933d316cbf07d921a3b8b07e5a285b95419eea0f0f2c5ced8f2db9a4"
    sha256 cellar: :any, monterey:       "da7c4645323d4f00a6bd25657be46c5e61d83d15813754ddfaca8f80aac3f94e"
    sha256 cellar: :any, big_sur:        "585e119bd2a16ce1757cd45917c8b4c6dde51487806ac4802860a1fe696dfd64"
    sha256               x86_64_linux:   "4be15e0fe2701d59381f04b750ff56dac40296bb3b141926d6b3ad78d7369675"
  end

  head do
    url "https://gitlab.com/mbunkus/mkvtoolnix.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "flac"
  depends_on "fmt"
  depends_on "gettext"
  depends_on "gmp"
  depends_on "libebml"
  depends_on "libmatroska"
  depends_on "libogg"
  depends_on "libvorbis"
  # https://mkvtoolnix.download/downloads.html#macosx
  depends_on macos: :catalina # C++17
  depends_on "nlohmann-json"
  depends_on "pugixml"
  depends_on "qt"
  depends_on "utf8cpp"

  uses_from_macos "libxslt" => :build
  uses_from_macos "ruby" => :build

  fails_with gcc: "5"

  def install
    ENV.cxx11

    features = %w[flac gmp libebml libmatroska libogg libvorbis]
    extra_includes = ""
    extra_libs = ""
    features.each do |feature|
      extra_includes << "#{Formula[feature].opt_include};"
      extra_libs << "#{Formula[feature].opt_lib};"
    end
    extra_includes << "#{Formula["utf8cpp"].opt_include}/utf8cpp;"
    extra_includes.chop!
    extra_libs.chop!

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          "--with-docbook-xsl-root=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl",
                          "--with-extra-includes=#{extra_includes}",
                          "--with-extra-libs=#{extra_libs}",
                          "--disable-gui"
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
