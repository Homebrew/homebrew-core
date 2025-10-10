class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  license "GPL-2.0-or-later"

  stable do
    url "https://mkvtoolnix.download/sources/mkvtoolnix-95.0.tar.xz"
    mirror "https://fossies.org/linux/misc/mkvtoolnix-95.0.tar.xz"
    sha256 "4e5481dee444f9995c176a42b6da2d2da1ba701cabec754b29dc79ea483a194f"

    # Backport fix for older Xcode
    patch do
      url "https://codeberg.org/mbunkus/mkvtoolnix/commit/a821117045d0328b1448ca225d0d5b9507aa00af.diff"
      sha256 "4d537e37b1351ff23590199685dfc61c99844421629a9c572bb895edced1ac67"
    end
  end

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "643eac71db818a4feb359fa12965db6550dddabb9c50a90ac9c8eda6a031d7da"
    sha256 cellar: :any, arm64_sequoia: "a248a3be39d81dfbaa201932cbbeccb2c400a1f5cddfdbcda18015dd026f4d1e"
    sha256 cellar: :any, arm64_sonoma:  "37a7dd36760f878e8b1adf2d0cdd3598e1762fcdbded25de3e4e946e532550e1"
    sha256 cellar: :any, sonoma:        "c1f7a3d2fa3e2d47da01656e00890182e9c6493cbb25749ca1e02a6500bce204"
    sha256               arm64_linux:   "0a1297ff8022eb53c3e785e162540554043f643a1200748659c9b7fa695d988d"
    sha256               x86_64_linux:  "1ec9e24af31fd5286896561bfd1b3d85cbc27b5cc9204dfed28280b663c48ce3"
  end

  head do
    url "https://codeberg.org/mbunkus/mkvtoolnix.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "utf8cpp" => :build
  depends_on "boost"
  depends_on "flac"
  depends_on "fmt"
  depends_on "gmp"
  depends_on "libebml"
  depends_on "libmatroska"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "pugixml"
  depends_on "qtbase"

  uses_from_macos "libxslt" => :build
  uses_from_macos "ruby" => :build
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  conflicts_with cask: "mkvtoolnix-app"

  def install
    # Remove bundled libraries
    rm_r(buildpath.glob("lib/*") - buildpath.glob("lib/{avilib,librmff}*"))

    # Boost Math needs at least C++14, Qt needs at least C++17
    ENV.append "CXXFLAGS", "-std=c++17"

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
    system "./configure", "--with-boost=#{Formula["boost"].opt_prefix}",
                          "--with-docbook-xsl-root=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl",
                          "--with-extra-includes=#{extra_includes}",
                          "--with-extra-libs=#{extra_libs}",
                          "--disable-gui",
                          *std_configure_args
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
