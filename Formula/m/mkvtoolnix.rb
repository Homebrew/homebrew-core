class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-94.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-94.0.tar.xz"
  sha256 "babbcff2362c9dd00b2e79336eff83fad177603a51a458ef1fa421b27fbc4703"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:  "485579359bd7ae98f4c5a27221bbd43b085e639f92f69ef0c4781722e0cb848a"
    sha256 cellar: :any, arm64_ventura: "978012bf3fb13774969555da0edae5cdb3b33a1f5277900b22abb972071fb387"
    sha256 cellar: :any, sonoma:        "d581e863bc283294a95c270196ed8b3862d84121dcdc22eabd5798852ea89603"
    sha256 cellar: :any, ventura:       "cb703a619e5810cfd0fc26d05b06e1f5d7c1624db06415cf1e72966ed1522a3f"
    sha256               x86_64_linux:  "78a481d675810c0db9b25a6eb0d89b826afc14ac449fe3a6bcb5d48b21a4be31"
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
  depends_on "qt"

  uses_from_macos "libxslt" => :build
  uses_from_macos "ruby" => :build
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  conflicts_with cask: "mkvtoolnix-app"

  def install
    # Workaround for Boost 1.89.0. Upstream fix requires regenerating configure.
    # Issue ref: https://codeberg.org/mbunkus/mkvtoolnix/issues/6143
    boost_workaround_args = if build.stable?
      odie "Try removing workaround for Boost 1.89.0" if version > "94.0"
      %w[ax_cv_boost_system=yes --without-boost-system]
    end

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
    system "./configure", *boost_workaround_args,
                          "--with-boost=#{Formula["boost"].opt_prefix}",
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
