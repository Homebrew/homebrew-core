class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-83.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-83.0.tar.xz"
  sha256 "6a8615436406c7fa45bfb2b6270da1bf06ea54cfcd13c3699643833e1d73ecbc"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "74f7ebdd88817b2b2b247da3d803650d131e769db763006f46c862b7f137789b"
    sha256 cellar: :any, arm64_ventura:  "5038b1a4580d3e7c5d2f33c89beef6f5463194a65a83dfe0c7ab84038b47f6c6"
    sha256 cellar: :any, arm64_monterey: "974a3578462c8571235e69db773f2ed851f8e222a0f545499f908000be305b70"
    sha256 cellar: :any, sonoma:         "17db801847ca0baad7ce263ea9786a69d700877db6e305006825ff9f4506f55d"
    sha256 cellar: :any, ventura:        "dcd135fe2ed417407421611e5c4b76376877f8dbad2eec9d026f4713b18504fd"
    sha256 cellar: :any, monterey:       "a66c32f713922e9989e4d29966ebf60f097b4fec7599d7e02492d52e360d95e8"
    sha256               x86_64_linux:   "7b4b828d2ea65e016d479948748a6ddbc4e424a1c8a6bb4a3eccb3aa2132d914"
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
