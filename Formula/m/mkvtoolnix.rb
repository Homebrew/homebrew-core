class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  license "GPL-2.0-or-later"

  stable do
    url "https://mkvtoolnix.download/sources/mkvtoolnix-96.0.tar.xz"
    mirror "https://fossies.org/linux/misc/mkvtoolnix-96.0.tar.xz"
    sha256 "509a1e3aca1f63fe5cc96b4c7272ba533dbcbb69c61d1c5114dccf610fd405cb"

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
    sha256 cellar: :any, arm64_tahoe:   "776e3fc01a1f51a1a1f0e9c5844b285d4af16adcee0736dfcc05acfc7cb34042"
    sha256 cellar: :any, arm64_sequoia: "0f64a3ada75c754fa79150e02a4836d53a41a4566b84fe59bc70aee522aba679"
    sha256 cellar: :any, arm64_sonoma:  "7208159c5de6a55aaca8a393f9f7f4eaf4c786b09d991a24f425f5c5423a62ce"
    sha256 cellar: :any, sonoma:        "eb0b55d8318e0ca6d0036b55412f4be018c7b1e4a6815d4fbde8af3433ab098b"
    sha256               arm64_linux:   "69d64fb1753b2a506aca453be6d02b509decb17ce8d384a0136b6385c1095719"
    sha256               x86_64_linux:  "0e64a7c6803260c78f6b987d86cda0f39b1e1bde9ecf14c7170e0d1a225f9919"
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
