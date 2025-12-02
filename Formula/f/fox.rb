class Fox < Formula
  desc "Toolkit for developing Graphical User Interfaces easily"
  homepage "http://fox-toolkit.org/"
  url "http://fox-toolkit.org/ftp/fox-1.6.59.tar.gz"
  sha256 "48f33d2dd5371c2d48f6518297f0ef5bbf3fcd37719e99f815dc6fc6e0f928ae"
  license "LGPL-2.1-or-later"

  # We restrict matching to versions with an even-numbered minor version
  # number, as an odd-numbered minor indicates a development version:
  # http://www.fox-toolkit.org/faq.html#VERSION
  livecheck do
    url "http://fox-toolkit.org/download.html"
    regex(%r{href=.*?fox[._-]v?(\d+(?:\.\d+)+)\.t[^"' >]+?["']?[^>]*?>[^<]+?</[^>]+?>\s*\(STABLE\)}im)
    regex(/href=.*?fox[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "27bc2f3e4a29b1b19bef2074fd9664b17d42a73f84ccefd593d0dd4ed3bc2a6b"
    sha256 cellar: :any,                 arm64_sequoia: "9c2013438ee383a44ff0b074698e0525e723eaea322745da017f9a18e254c55d"
    sha256 cellar: :any,                 arm64_sonoma:  "680d4ca9e11e09ae8022d3e66d38df4ca5c7aa3c9178d9768d7968e89c8afa8b"
    sha256 cellar: :any,                 arm64_ventura: "913fd94fc1d4051b12d88df4659942892cf9c3e05fd4ad582c2a2fc38efe0def"
    sha256 cellar: :any,                 sonoma:        "6e12aa948749cb6bb0618a376ced17b39a3c6d043b97598b91e31ac1c2d09306"
    sha256 cellar: :any,                 ventura:       "365ecefc5bf0fa8070f7b13604b4706cdf13e0510ede27f0531d905664d1672e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afeeb42bdca4ebed1fe9e1b177cd23eccc01aa296c5395722392e59e84ac8e2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "192f9a030ddd8f3613d2bc213b843f9ca0b667f08a67e3a5dbd43e84ff3b8ea5"
  end

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "libxcursor"
  depends_on "libxext"
  depends_on "libxft"
  depends_on "libxrandr"
  depends_on "mesa"
  depends_on "mesa-glu"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libxfixes"
    depends_on "libxi"
    depends_on "libxrender"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # Needed for libxft to find ftbuild2.h provided by freetype
    ENV.append "CPPFLAGS", "-I#{Formula["freetype"].opt_include}/freetype2"

    system "./configure", "--enable-release",
                          "--with-x",
                          "--with-opengl",
                          *std_configure_args

    # Unset LDFLAGS, "-s" causes the linker to crash
    system "make", "install", "LDFLAGS="
    (bin/"Adie.stx").unlink
  end

  test do
    system bin/"reswrap", "-t", "-o", "text.txt", test_fixtures("test.jpg")
    assert_match "\\x00\\x85\\x80\\x0f\\xae\\x03\\xff\\xd9", File.read("text.txt")
  end
end
