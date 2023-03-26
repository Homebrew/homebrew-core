class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-75.0.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-75.0.0.tar.xz"
  sha256 "e7ad116f374cdf8370fa566ed7fe23ecdcf413dbe6dd90ab3f82904d0cf7516f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "93872cd7335f3ca7c8541f5f9a4d2aa9b09d7298c31355366b4ddfa8a7a8f981"
    sha256 cellar: :any, arm64_monterey: "c505b401693afdc59acb4c6004c23451930e56466ca063085e55bbe139b0e5fe"
    sha256 cellar: :any, arm64_big_sur:  "959104fd43b77f60ce3d09c1de8ef36dabbbc9e43729070656418b5653e47516"
    sha256 cellar: :any, ventura:        "c67e57868f0d5f530c80aa1fe1b0795187e9f5be511f2064f61079fda54d987d"
    sha256 cellar: :any, monterey:       "2ca8007fe4176cd12ba0ac0961db777bf73a16cb839d2d1927ff8eb4e570e5aa"
    sha256 cellar: :any, big_sur:        "62cc23021a8cfe4c09fb3401a7453cd84d1e13df2c3aa5c824227faf23df6205"
    sha256               x86_64_linux:   "06865c28aa6fc8c760139d6d4357483b7cf1418d8b76ae5e6663e0892ab7179f"
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
