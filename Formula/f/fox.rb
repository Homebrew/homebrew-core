class Fox < Formula
  desc "Toolkit for developing Graphical User Interfaces easily"
  homepage "http://fox-toolkit.org/"
  url "http://fox-toolkit.org/ftp/fox-1.6.58.tar.gz"
  sha256 "5a734b84d76d2f8e334e26ff85dd3950d3fedf53057a4d4b19fd4a712c8d5b81"
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
    sha256 cellar: :any,                 arm64_sequoia:  "03d4467da14575e4fc72068fc604e5b5881a3c872cc8ce0836b47cf7e0711935"
    sha256 cellar: :any,                 arm64_sonoma:   "a7d81645a79ad7dc2cfef61762146266c510354d0b8f47c58acc329d65f1adc2"
    sha256 cellar: :any,                 arm64_ventura:  "254668d35c9764f82cb174d6a5ea420497a25f4c73e897163daa0ebcb7da69cc"
    sha256 cellar: :any,                 arm64_monterey: "ebb32475c51e23f89bd5e88b425a90a074d9cfaf6863c07e21db2eba5eafd818"
    sha256 cellar: :any,                 sonoma:         "e325ea4ff9c8fb5ab63b3edb2600205838b08434f542ab9b0642968afcb7fa90"
    sha256 cellar: :any,                 ventura:        "17702bfb3962e3d989912ae9da1ba0aebff4da22d827b47aaaffbc249b528d5b"
    sha256 cellar: :any,                 monterey:       "d5ac193139082652a763aa9c33f805cd7afe1b448799e5db198d6cdc706efcf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a67a558528e60b0476f36bc1b2ea18f93e1b751c0b0fa2b526f3d473dcea7b53"
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
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
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
