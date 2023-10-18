class Fox < Formula
  desc "Toolkit for developing Graphical User Interfaces easily"
  homepage "http://fox-toolkit.org/"
  url "http://fox-toolkit.org/ftp/fox-1.6.56.tar.gz"
  sha256 "c517e5fcac0e6b78ca003cc167db4f79d89e230e5085334253e1d3f544586cb2"
  license "LGPL-2.1-or-later"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6490dbfbbd60bd7f4b4b14fcbfe774d3e758c23486484ece21a6b09dd14867c2"
    sha256 cellar: :any,                 arm64_ventura:  "e3a425ba8dc21f31f67bbf515030956f044f42af7e06a12ed5eea4c00b10feb0"
    sha256 cellar: :any,                 arm64_monterey: "825cfc53620606c3366928e1e7da404bc11e31283b7de29497ba504652abe149"
    sha256 cellar: :any,                 arm64_big_sur:  "8328ac03359070c9f20537a6277d15d8a815e35387bba1c5cdcd11af51d4baa6"
    sha256 cellar: :any,                 sonoma:         "84fc67b6f359c4b84e833c878af73eadc1e433e83d036834eacf4fe40194e6b4"
    sha256 cellar: :any,                 ventura:        "74567e8739db08f0369e2d6177c0b6e38d5dc862342042b164682b0cddf7d64b"
    sha256 cellar: :any,                 monterey:       "2396ca931860ca6523b7507a084ec9c5518493be593c5cf6a0a56735619e16c5"
    sha256 cellar: :any,                 big_sur:        "bb8bdbecbd7b8c4c8f9c3caa90f17063579e1ecbdd9beea3276330fb8116d907"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8721a37c018aedef917055183eede83c8a1cab283371e2be629d85c9e006a0b"
  end

  # There have been numerous attempts to update this to 1.6.57 (latest stable)
  # with no success. If you are reading this and can fix the build, please open
  # a PR and we can undeprecate this formula
  deprecate! date: "2023-09-03", because: :does_not_build

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
