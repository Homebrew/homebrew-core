class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-102.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-102.0.tar.xz"
  sha256 "9f0a810f17c7df8adb9064a3a41d5784399be412d19704cf080745ad7d45da30"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2c482f4b37e3685020a3a4fffd7a9fc96988e2ca191b17a8feec38e34169a8af"
    sha256 cellar: :any, arm64_tahoe:       "42c3c56d96d203ce13747f766f64f53c8d6ede17ae41ff1a398c1288c1dd38ad"
    sha256 cellar: :any, arm64_sequoia:     "e9b3265aaca84eb862c76a1fba130b2563d917acf720f6eb0daf5933e9680d9f"
    sha256               arm64_linux:       "1690e3610d1dd777b77479e43f3b044b82ccbc1d4e61ae915a2eafa9affeea6a"
    sha256               x86_64_linux:      "b3acaa1a85ba243e0c97906b3ca848db4d63d982e6b08b00d5332686cc4b92bb"
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
