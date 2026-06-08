class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-99.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-99.0.tar.xz"
  sha256 "bcd99b49b0d18f0d7321fbbe36bbc7d2456dbfe707ba6ac3ce3f9e6bfcacaed6"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f05d9439d294873a94e59f8591cc3161da561cec5473143e376653a06c1dd563"
    sha256 cellar: :any, arm64_sequoia: "b893c02620f0ec706014fc9c5018b9e4a018b034f996b95b232b290014c630fd"
    sha256 cellar: :any, arm64_sonoma:  "ce1b5632c8a94d9a0dbf6b26f506b9233c73e7a317c05b4c859e9fd110bd4868"
    sha256 cellar: :any, sonoma:        "87001e7ada2d79387d992b0b799974339c85c2f0a27571cafe35263208bbbeb9"
    sha256               arm64_linux:   "789cd350f21ea292d263d6a3a4323578ddd4e6056b721f53afbf4a1ddf86ee52"
    sha256               x86_64_linux:  "2ae17be7cd631ce80624116639d569ad81c590224435744960c3bcb9c6247ead"
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
