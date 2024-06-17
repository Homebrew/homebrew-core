class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-85.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-85.0.tar.xz"
  sha256 "702442c80706c7c770ac04f7b4eed7a57e9e03ead6c5e6e90b9655dd84c8d829"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "ded9d414d86eaaf8b7a146d15cbf3b1bf4322a1ac1eac0ae0b91dd3365e17404"
    sha256 cellar: :any, arm64_ventura:  "641821e1ac280a7966d31874b85913124c4fe2999d8f75b946991b81c15f6428"
    sha256 cellar: :any, arm64_monterey: "882d12d27b5738c333ed4c57b09c07c8eda1fbd2afc5bcbc3498a1cc4a6720ec"
    sha256 cellar: :any, sonoma:         "e6cbc1baad712026dea9af683e8b8db08ff9df73001dca96b08a3a4df7623205"
    sha256 cellar: :any, ventura:        "28e8a3d7ab3e7a7389e996be809f761246ec0fce974caf0efa13d7ce33df47e8"
    sha256 cellar: :any, monterey:       "6b48a0b9fb8a93ba89fd35f017b09111c170f826f76c29e7d227f8609ade7ff4"
    sha256               x86_64_linux:   "ab4cac9226131f7ae641668b9667dbbf10f06401e0ed05928063dca8429d8fc1"
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
  uses_from_macos "zlib"

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
