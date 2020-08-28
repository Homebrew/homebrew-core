class FsUae < Formula
  desc "Amiga emulator"
  homepage "https://fs-uae.net/"
  url "https://fs-uae.net/stable/3.0.5/fs-uae-3.0.5.tar.gz"
  sha256 "f26ec42e03cf1a7b53b6ce0d9845aa45bbf472089b5ec046b3eb784ec6859fe3"
  license "GPL-2.0"

  livecheck do
    url "https://fs-uae.net/download"
    regex(/href=.*?fs-uae[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "124950f0053e117fa271e182e705b2c9bee21f2572e371c1ff18f106ad777c5a" => :catalina
    sha256 "446a54d257e764ec9df2b825b7dfe9dbb266e5ad586f439d75223c986ce21aa8" => :mojave
    sha256 "b540e43634bfbbe75fe6f143a9bec8aeae85e29028f44e3d54bb979c4630cc51" => :high_sierra
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
