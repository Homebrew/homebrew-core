class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-67.0.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-67.0.0.tar.xz"
  sha256 "db68be91ee8a0b688d924cc00d3bac9349306d54c29ce44a555728c1abb7d3ec"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "fbc6c2583e7d61381d324d89675a6319f44b9066e31f2421f08634eaa61edd86"
    sha256 cellar: :any, arm64_big_sur:  "c6d49253e3d5ae41c912c9610f33494c7e32816ac921af577aa6d501b9290710"
    sha256 cellar: :any, monterey:       "9b4182a605831a003b58639dde017434653c028ebba6480f2b4b6fe6c6051a8b"
    sha256 cellar: :any, big_sur:        "dac3145023f72e54227899235618805a146f4e9ce3894d973be8972b6f210c0f"
    sha256 cellar: :any, catalina:       "80bc2c0ea2ce1707c21c5e7f7d12f3a0c14e4d910743fff2cdfecd394421224c"
    sha256               x86_64_linux:   "145b25b736b02658e18a41ebb0415e786a8237ce156d0d084271717d5326d1b4"
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

  on_linux do
    depends_on "gcc" => :build
  end

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
