class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-78.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-78.0.tar.xz"
  sha256 "6a50fce8c66c55410e0df2a6952f0bab7a3c92914db7feb285b9f1bb03fcd0d3"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "4f27626fb33f6bf9885f5adacc1dec6e3d336134d48550e41636a6c4c8b604e6"
    sha256 cellar: :any, arm64_monterey: "24a6b9fd94b15e01bce47ea963e57a58a3d339483feeb4171f07d20292afc5d4"
    sha256 cellar: :any, arm64_big_sur:  "aabb6e7e81f4785fbac830fa5f0035bbd85a47e7254076c8869a44dc9bf63167"
    sha256 cellar: :any, ventura:        "28d4e4b55c9483dbe9c1b710c872bdf840f96c794215304418ca2bc69fd72ccd"
    sha256 cellar: :any, monterey:       "6f9f45a56c99a8c5cda3d5dc35dea803cd5bcc7be3f14e6043215ffd02d5f704"
    sha256 cellar: :any, big_sur:        "1659590b9dd11aef5b7e08ec0136436bdf8094c07060b39833d12d2a76773a6a"
    sha256               x86_64_linux:   "613b2ee13c99b0deeffe5cad22d30d0c2c08d6f2cb0ad4556d4980d5c54ebb14"
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
