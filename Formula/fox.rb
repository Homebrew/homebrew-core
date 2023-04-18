class Fox < Formula
  desc "Toolkit for developing Graphical User Interfaces easily"
  homepage "http://fox-toolkit.org/"
  url "http://fox-toolkit.org/ftp/fox-1.6.56.tar.gz"
  sha256 "c517e5fcac0e6b78ca003cc167db4f79d89e230e5085334253e1d3f544586cb2"
  license "LGPL-2.1-or-later"
  revision 3

  livecheck do
    url "http://fox-toolkit.org/news.html"
    regex(/FOX STABLE v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bc5dd90eb1c5b974dba13c355be3720bc322fe9852c6863d619324f923bc0256"
    sha256 cellar: :any,                 arm64_monterey: "41ad7e9c440defe145780c8ba2a3eabe8f48276013dbc88d743540c083bfca3c"
    sha256 cellar: :any,                 arm64_big_sur:  "ba7b09dfb7926bb605af6793184b2acebb49450e70d8a5c9151a35a51754f4eb"
    sha256 cellar: :any,                 ventura:        "8fd1fa22a1cbbabef9d01d3a87cde095706f9b5a86558543bd953dba55cb5fa0"
    sha256 cellar: :any,                 monterey:       "c70d21e9cae3071d7c83df9b82b10a5ddfcbf292989eb6e436741ea7fcbf1d29"
    sha256 cellar: :any,                 big_sur:        "13f597f1552171dc9cbb12ebe818234078d3d4b05e381366c7f2b59736c2deb3"
    sha256 cellar: :any,                 catalina:       "78fae09af588993705203577e978c7846792d7f86215a8c3f63adccfc5b36d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "230354829d1ed0956e2fda9cb8387632283298708c80ae53440f135480e0a187"
  end

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "libxcursor"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on "libxft"
  depends_on "libxi"
  depends_on "libxrandr"
  depends_on "libxrender"
  depends_on "mesa"
  depends_on "mesa-glu"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # Needed for libxft to find ftbuild2.h provided by freetype
    ENV.append "CPPFLAGS", "-I#{Formula["freetype"].opt_include}/freetype2"
    system "./configure", *std_configure_args,
                          "--enable-release",
                          "--with-x",
                          "--with-opengl"
    # Unset LDFLAGS, "-s" causes the linker to crash
    system "make", "install", "LDFLAGS="
    (bin/"Adie.stx").unlink
  end

  test do
    system bin/"reswrap", "-t", "-o", "text.txt", test_fixtures("test.jpg")
    assert_match "\\x00\\x85\\x80\\x0f\\xae\\x03\\xff\\xd9", File.read("text.txt")
  end
end
