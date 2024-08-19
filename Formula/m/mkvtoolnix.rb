class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-86.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-86.0.tar.xz"
  sha256 "29a9155fbba99f9074de2abcfbdc4e966ea38c16d9f6f547cf2d8d9a48152c97"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "6e1e9a95f20805baee179943e3de46f4dafd26ac89159ecfda90ddea3a621d3e"
    sha256 cellar: :any, arm64_ventura:  "094d79990d30405b4b576e01f1807a87b7f5b01801deff701ae996b127230aa3"
    sha256 cellar: :any, arm64_monterey: "88e22898eb6a0e2a004a26fa0c1972a29cc144bb0a1922d5d243ddaec9ef2df0"
    sha256 cellar: :any, sonoma:         "f35bb84cb240167f206fdfee7eef839f2788e5f92b6d96352bc5041997f84844"
    sha256 cellar: :any, ventura:        "114eb2b80e0dce42e977edaa859a8ef3e283b6512d4541a37f94fb28fffd42da"
    sha256 cellar: :any, monterey:       "5cf493fe882637a02c5cd2dceedb90bbb2172b00c78ff66400bf180c6524bb93"
    sha256               x86_64_linux:   "3fd17211454629853e8122aaefc1901841dd490245fdfc7f5274c471f4186ffe"
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

    system bin/"mkvmerge", "-o", mkv_path, sub_path
    system bin/"mkvinfo", mkv_path
    system bin/"mkvextract", "tracks", mkv_path, "0:#{sub_path}"
  end
end
