class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-86.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-86.0.tar.xz"
  sha256 "29a9155fbba99f9074de2abcfbdc4e966ea38c16d9f6f547cf2d8d9a48152c97"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "2b0bdd372ba2891d09290cffb8baedecfd4b130fa81c59ac2b7cd0b6800964f9"
    sha256 cellar: :any, arm64_ventura:  "868bbd894eee9c2dd06ca817bbc7a4641460e217cb801c53a4473975e3444f91"
    sha256 cellar: :any, arm64_monterey: "e6c0f5b748b852696ad8bd824435b390c11d0b420179a358754644e52dfd683d"
    sha256 cellar: :any, sonoma:         "f10e771e6c4415163e4f7216de3686e9ac86b55740dd00463f2b8aac92a8312c"
    sha256 cellar: :any, ventura:        "c0a2932a31de1c5f65e906b980fe086b4f3990c777b89ad86060b55c1ef54e46"
    sha256 cellar: :any, monterey:       "e71f5a07d85e274b7631aeaca8a3e7f139367c5a535940bc1bd409961f7c4dec"
    sha256               x86_64_linux:   "7182ac8ed3066ad615d32ca68960ee8d744e3d86e795f5fcd5348f9ed62b5190"
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
  uses_from_macos "zlib"

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
