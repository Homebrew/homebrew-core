class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-73.0.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-73.0.0.tar.xz"
  sha256 "f31a129723571b46a974bc5d57d73733c1245ee429afd6ddaf274038e94e2280"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "f0cea86ffb92a59f4be256e96438d6f5cb1b262de693d27e81c4ef249b2008cf"
    sha256 cellar: :any, arm64_monterey: "aa8c5e72674872b19d967798ba1559415014e8dad6b08ffcdb9909350ce0a9d5"
    sha256 cellar: :any, arm64_big_sur:  "e1bb6caa58dbc6efb3ab5d2562e8108415066a73b6ab1c041eeaa3691693a864"
    sha256 cellar: :any, ventura:        "cff4cde7d2c1ccd6dc1a2b1f597e1ea9cdec419ef040510e0aa867a6767d9eae"
    sha256 cellar: :any, monterey:       "3209705fba2491f8b88eecd773f7791c5f40cb163a20ab0615884ef92d8aefed"
    sha256 cellar: :any, big_sur:        "85d97db0d53531dae442e4c676e265a86a78123ec6bc35ddce571edd4162542c"
    sha256               x86_64_linux:   "e57fa5e5ad6088a5b84866e2afa1c7b0d176f2769fec9818420ca4acb320564e"
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
