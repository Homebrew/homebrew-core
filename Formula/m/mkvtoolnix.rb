class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-84.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-84.0.tar.xz"
  sha256 "e9176dea435c3b06b4716fb131d53c8f2621977576ccc4aee8ff9050c0d9ea7a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "47a500b12bbed6e057aaa2a22f4c8489304052933f4d800575fe16deecc03be5"
    sha256 cellar: :any, arm64_ventura:  "bccfaf7206ea875ee93fcce1ccd1bf9fc57965bebf277659e422f98fcc34467b"
    sha256 cellar: :any, arm64_monterey: "12070d27b17bd8a698b0afc1be57c0cecd22167c65170a48468a31f6c8e5d24a"
    sha256 cellar: :any, sonoma:         "10d1b0f36805054943de6c8ab0ae4f1d19dd87e98856ef2dff3756443d3d2434"
    sha256 cellar: :any, ventura:        "ead023f7dcb4e5e7e68dd56f5f6f58f15ad69c8580d607d8a506c4193583f4bf"
    sha256 cellar: :any, monterey:       "2da18f9062c1026281bd4d4cbe2d54aad94f745881dbc0b6176a9f7b9c10b3e3"
    sha256               x86_64_linux:   "cb0608824a6312223e71b5d512e8de188d0967c487b688d481c1fed9dd37ec3c"
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
