class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-75.0.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-75.0.0.tar.xz"
  sha256 "e7ad116f374cdf8370fa566ed7fe23ecdcf413dbe6dd90ab3f82904d0cf7516f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "7024a01f780a370db12c32d469f658ed115914c5876eabad025dfd96e6e4de5f"
    sha256 cellar: :any, arm64_monterey: "afba11f14b9e324ea0f60560202274ab7cd19539dc6878d9563f2c192bc7b8ae"
    sha256 cellar: :any, arm64_big_sur:  "12531bb563990776da42543407cbc281ca892317c6abfeaabf65fa0002099a37"
    sha256 cellar: :any, ventura:        "2efd5b8179d11f3ca462a55c6dfcc42db25bdaae4365e33bca19da1eda2e8152"
    sha256 cellar: :any, monterey:       "af0c3361805e8351a1870469b98b82957b7b53f6d2a6f0c6fbea393fc4edcc5e"
    sha256 cellar: :any, big_sur:        "2612e098a8b9a84ecdaad9f006552efd0a5d9fcd4566e9aad823249e7e8c9ca3"
    sha256               x86_64_linux:   "d3b3c2fea864d4b0b9a0ab81c3ccfa2dfafc999e057caa82f030093ec21c6b97"
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
