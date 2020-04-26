class FsUae < Formula
  desc "Amiga emulator"
  homepage "https://fs-uae.net/"
  url "https://fs-uae.net/stable/3.0.5/fs-uae-3.0.5.tar.gz"
  sha256 "f26ec42e03cf1a7b53b6ce0d9845aa45bbf472089b5ec046b3eb784ec6859fe3"

  bottle do
    cellar :any
    sha256 "6263809adcc7aaf08b7f7eb3410810c4e9e98636571bda57817b66836d79c5ca" => :catalina
    sha256 "46c073176f059971ae1b32706f023537a24ca0c96fa7cab473c6589fe101d001" => :mojave
    sha256 "d787653d08cb8d640a1152ab977b1733c611612f48707efcf1f1bac61e262078" => :high_sierra
  end

  head do
    url "https://github.com/FrodeSolheim/fs-uae.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glew"
  depends_on "glib"
  depends_on "libmpeg2"
  depends_on "libpng"
  depends_on "openal-soft" if MacOS.version == :mavericks
  depends_on "sdl2"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    mkdir "gen"
    system "make"
    system "make", "install"

    # Remove unncessary files
    (share/"applications").rmtree
    (share/"icons").rmtree
    (share/"mime").rmtree
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/fs-uae --version").chomp
  end
end
