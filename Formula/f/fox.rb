class Fox < Formula
  desc "Toolkit for developing Graphical User Interfaces easily"
  homepage "http://fox-toolkit.org/"
  url "https://distfiles.macports.org/fox/fox-1.6.59.tar.gz"
  mirror "http://fox-toolkit.org/ftp/fox-1.6.59.tar.gz"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "91240fb02b90a3c3efdaa73e6deca2662ec50404014dd405762adcaf17db7ec9"
    sha256 cellar: :any,                 arm64_sequoia: "36e79082d471128dac96dc31fcff7fff98a4b8a0656872cd130c0fb24e8b2597"
    sha256 cellar: :any,                 arm64_sonoma:  "036570ec8faf4ace5e79bf8b14e87c7b937555326802fa13277a91ee1680c232"
    sha256 cellar: :any,                 sonoma:        "1d251b692e7f74a95c853d492dd1a54714372ee61c4ee8bd94fc5b23feb49d5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d411539e13366056c6597b528c53bec28e3fdaecfef3fbdb4e410c2f2a500ba6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f7c54833495b786ec99c5cd9b5e40794471d9caf3e531173c63b2d4fc2f28bc"
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

  on_macos do
    depends_on "libxfixes"
    depends_on "libxi"
    depends_on "libxrender"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
