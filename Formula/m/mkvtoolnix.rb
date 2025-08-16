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
    sha256 cellar: :any, arm64_sonoma:  "968a68332a5971b5b86f9c7c9281be6f679ce2b6a9d3582456f5034d0302c9ac"
    sha256 cellar: :any, arm64_ventura: "2bc40424584c7aec7f1d7c0d8cc932c6a8338166621c30035aa7fc9104501e7d"
    sha256 cellar: :any, sonoma:        "2f34d7626c7547671ed58e53c8252a27eb17b396f168cb0ee48fb83bbfafe26c"
    sha256 cellar: :any, ventura:       "d16b4834c664105f9509530a5e924acb166303d83d2de98d8a7d803911f19c45"
    sha256               x86_64_linux:  "1ccc688addddf67029fbadb91f4c9f74e6fd7d3dedf54e00fbd3ffc42e9e22b6"
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
  # https://mkvtoolnix.download/downloads.html#macosx
  depends_on macos: :catalina # C++17
  depends_on "pugixml"
  depends_on "qt"

  uses_from_macos "libxslt" => :build
  uses_from_macos "ruby" => :build
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  conflicts_with cask: "mkvtoolnix"

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
