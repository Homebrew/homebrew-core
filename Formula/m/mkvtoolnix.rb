class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-100.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-100.0.tar.xz"
  sha256 "74480d07a261beeaa8baf898248e668ecc56335e2527bbffa841ef056dc028a1"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2cb5d24bb8b5553d70ba187a16c17732df49270bc42f109e11aae8fa9c98e059"
    sha256 cellar: :any, arm64_sequoia: "6c529514df4e0ef58c486871fa6c9a4e640e2dc1b6b109cfddaca1274474d2b4"
    sha256 cellar: :any, arm64_sonoma:  "4268f1f41e1807b4ff64fc944a7eacbb40d14cb384b1a9938a0d5850c245d031"
    sha256 cellar: :any, sonoma:        "58e29b0da0257af913932e788cb37644b8ccaa88988aea9505e7775c44960f32"
    sha256               arm64_linux:   "dcdbf2577410caafe48d44c5793f7a6d8a6c10aaa6b1735102da58614588ecde"
    sha256               x86_64_linux:  "4507c52a90a798a9df09d6da8560195f6e4d30466029e2eeacae0dc241bfdd81"
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

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with cask: "mkvtoolnix-app"

  def install
    # Remove bundled libraries
    rm_r(buildpath.glob("lib/*") - buildpath.glob("lib/{avilib,librmff}*"))

    # Configure script needs help with C++ standard in Boost Math
    ENV.append "CXXFLAGS", "-std=c++20"

    features = %w[flac gmp libebml libmatroska libogg libvorbis]
    extra_includes = ""
    extra_libs = ""
    features.each do |feature|
      extra_includes << "#{formula_opt_include(feature)};"
      extra_libs << "#{formula_opt_lib(feature)};"
    end
    extra_includes << "#{formula_opt_include("utf8cpp")}/utf8cpp;"
    extra_includes.chop!
    extra_libs.chop!

    system "./autogen.sh" if build.head?
    system "./configure", "--with-boost=#{formula_opt_prefix("boost")}",
                          "--with-docbook-xsl-root=#{formula_opt_prefix("docbook-xsl")}/docbook-xsl",
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
