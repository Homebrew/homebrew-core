class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-79.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-79.0.tar.xz"
  sha256 "f039c27b0dfe4a4d1aa870ad32e20a28a5f254de6121cb12a42328130be3afbc"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "8c5011f8c3b938a0732b2d207c46188a192d57d3dd5ff2c9119e283e36cb43b1"
    sha256               arm64_ventura:  "da4409f3f6cfefecd63b4f5acf5c2076dd0d040ffaf132d50fb8b65b238a8288"
    sha256               arm64_monterey: "6739341aa687b69209e96982148f76f647401bfa6e96607b39262ccac4c5f25f"
    sha256               arm64_big_sur:  "28f75365de508bf6ee4b68b9e07dbef275a8c028b507e6ed32f7c5598e0c0c26"
    sha256 cellar: :any, sonoma:         "a7568c9a9e688820b9ff6ffcd49f5af88d5f14a5aece14b0b5d9c33d4e4aab9d"
    sha256               ventura:        "ff859363a7e469d414c91c487bad0cde33bf856bf9f6707be0f573d0ac9da70f"
    sha256               monterey:       "3b79896e71ed53f1aa5d7f323634e9746a13f23dffa482b24c99a1449a0ca7de"
    sha256               big_sur:        "f9f690bba57f68bedd5ba99d24b9bea98c26e7c71a82e5102b6f7e358fa95406"
    sha256               x86_64_linux:   "d00cd6fc2cdb47c70f5f9b9545d62caaf1f4128b4a8ccd2bef692fcea7a54398"
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
