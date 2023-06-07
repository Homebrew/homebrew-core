class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-77.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-77.0.tar.xz"
  sha256 "5f0cb2b7afe39226d0d41bd7ba098db669981da8c4b455862faffae04ca8e57a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "e2d9db0cd04742dab30928d0769e4a9b0dc7988195d7165509e0eefe1f90c118"
    sha256 cellar: :any, arm64_monterey: "3e6800e26029c6b657c64710fed95e52ec3665d4d299476f82155f540cfecec2"
    sha256 cellar: :any, arm64_big_sur:  "4109124f77830d823bd08aad62d5469a5e99e12abc3aa7fe025ba46c5df11c77"
    sha256 cellar: :any, ventura:        "8ac22b44f021eb92e7607a2a83cf525691c95bf8deb4a860945352b68a6a91a5"
    sha256 cellar: :any, monterey:       "ba137378a3097fc9b232cc668b790c32f327459ff54640e826ea62632079cc96"
    sha256 cellar: :any, big_sur:        "2ac9fdf897baa9751155d9a4664cdf0043339c8d59f6b45e43632bc2fa6c9b98"
    sha256               x86_64_linux:   "dfe36a34c51ebe4dea2aadcae541a6fe592bd2d6f175fad41cbcf501a88eee60"
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
