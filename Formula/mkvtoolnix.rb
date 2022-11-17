class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-72.0.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-72.0.0.tar.xz"
  sha256 "3bd1005baf397f1d70619c2f2c52af9de8ce75995830e790e429c0943fd08000"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "2e4e2ba1a9ee49a0866d2283f3441068fbb7c7001a4ed4b9a5fcf89c1e1c6607"
    sha256 cellar: :any, arm64_monterey: "de67e46dd78d99bd2374d7286f9067b0c3c78640b142ec66641278c9a639d5ae"
    sha256 cellar: :any, arm64_big_sur:  "ee7d259784e6fc283c64e4654b90f6b784965ddbafbef2145d60962183634dcb"
    sha256 cellar: :any, ventura:        "fce390953f64e9b4735778207960b0e622f96a400c48700a22aa4dec52f5eb51"
    sha256 cellar: :any, monterey:       "dc828e07eee476d6cd1e9d7c0685ea1ffb6212f3fb85a6cba4ad3530dc67e464"
    sha256 cellar: :any, big_sur:        "2535797cbe4f034f9a96577a7b84002a873de65f7bbe0cc4cbe6a465c249945a"
    sha256 cellar: :any, catalina:       "b292698f1e6b839442aefc9c2fd62cde2c1f22ed8b6f9848469f853433f54e0a"
    sha256               x86_64_linux:   "5be9db1f36fa183f8c27ccd9f2913c75e6a0019aed74a7b492dcb640da3c5b0f"
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
