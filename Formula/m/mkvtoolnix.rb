class Mkvtoolnix < Formula
  desc "Matroska media files manipulation tools"
  homepage "https://mkvtoolnix.download/"
  url "https://mkvtoolnix.download/sources/mkvtoolnix-83.0.tar.xz"
  mirror "https://fossies.org/linux/misc/mkvtoolnix-83.0.tar.xz"
  sha256 "6a8615436406c7fa45bfb2b6270da1bf06ea54cfcd13c3699643833e1d73ecbc"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mkvtoolnix.download/sources/"
    regex(/href=.*?mkvtoolnix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "e77925b5298f916e2ea0aa4a8b133233ed6d7094d88f20d5282759cbe15acbd7"
    sha256 cellar: :any, arm64_ventura:  "6701ebaca829a89a8fb9aa652210873e6d168404a4668d6e2616ac36157b2f74"
    sha256 cellar: :any, arm64_monterey: "b3c73321cdab15c62f692e1b2394966a8a5f75184183d8806c104d1270388998"
    sha256 cellar: :any, sonoma:         "20d93f1c048539632c015143339a3187972e547a2072d0c9e92bbf55028b3b52"
    sha256 cellar: :any, ventura:        "1dc3a280e16427c6671840867edcfc8989dcdac863c18693e499b36f4a4bc40c"
    sha256 cellar: :any, monterey:       "3fb0548fa901f7d96f08b8ec75f424c119be9ca63705056618dd783cf5079cb0"
    sha256               x86_64_linux:   "213de3d2bc0cdab190616f4b4941446de426f9a0b4569b26d2becb54c48ba8b3"
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
