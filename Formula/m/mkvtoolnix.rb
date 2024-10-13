class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-87.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-87.0.tar.xz"
  sha256 "01cdfcbe01d9a771da4d475ed44d882a97695d08b6939684cebf56231bdee820"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "126ad3b6bc4f63e1c3426c59140c23ac56a8ea3305aee7e43fb1e88c303a4c4e"
    sha256 cellar: :any, arm64_ventura:  "933d841ea4b7613436e2f6340d17331168fa267532062f063ed4f5a248462df1"
    sha256 cellar: :any, arm64_monterey: "3bc009dc66d7e16ccdad989823bbc2e8d90b8bb16d31d93ee6d648326eada8c1"
    sha256 cellar: :any, sonoma:         "0aaae4a02e0add729100916f00fa9718c8fcf9f0b420056527c80eb674166a3c"
    sha256 cellar: :any, ventura:        "6ed8c7620429cccb7c3c8b321920fc09e3e23b30b1e3acc2207d05956e2a1d56"
    sha256 cellar: :any, monterey:       "d0af3ab6e462fdff3f74db37ac06f11ed4663a16dfa366d50af7a78fcb61c1be"
    sha256               x86_64_linux:   "06aa9eddcb5206281a1e7075b42112b1db84196265cb45292c3d46dba44e4b45"
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
