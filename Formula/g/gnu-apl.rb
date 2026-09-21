class GnuApl < Formula
  desc "GNU implementation of the programming language APL"
  homepage "https://www.gnu.org/software/apl/"
  license "GPL-3.0-or-later"

  stable do
    # NOTE: keep url and mirrors even if they don't exist
    url "https://ftpmirror.gnu.org/apl/apl-2.0.tar.gz"
    mirror "https://ftpmirror.gnu.org/apl/apl-2.0/apl-2.0.tar.gz"
    mirror "https://ftp.gnu.org/gnu/apl/apl-2.0.tar.gz"
    mirror "https://ftp.gnu.org/gnu/apl/apl-2.0/apl-2.0.tar.gz"
    sha256 "24bbb744fce47e62837234a053bdeecee51b9ea61c82c79f7cc191bc6a54c0a1"

    # TODO: Remove with patch
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    # Apply Debian patch to move integral.py
    patch do
      url "https://salsa.debian.org/debian/gnu-apl/-/raw/9553c1ebcfa46cdfe3717378ede5f37dcaceaf0f/debian/patches/0008-move-integral.py.patch"
      sha256 "5895566af3b0c7f69dccbea06dac99cb463ff213c4d1daf4d9a157f36cf795b9"
      type :backport # changes included upstream
    end
  end

  bottle do
    sha256 arm64_golden_gate: "2063be39d2ad488f60ce2f1d08a77000ad669363e66d42c875ee1154c82b0400"
    sha256 arm64_tahoe:       "415920b4c553171c5a0eceb1953989049b462e4134daf8e04cb7209fa267e8c7"
    sha256 arm64_sequoia:     "066f0d40a60f92a1d7f4b0fd5aa8d18012c976ec7cedef011f2979ff7cea2176"
    sha256 arm64_linux:       "5dc6f9e6a8c99d7df7fd81f25083490892b7e6355521a2687d2a8492b75c9b23"
    sha256 x86_64_linux:      "a5550e649fd32123c5f133bf0b4b28ff3ba2a94102625a96d5621a48a35c6cc7"
  end

  head do
    url "https://svn.savannah.gnu.org/svn/apl/trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libpng"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "pcre2"
  depends_on "sqlite"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  on_golden_gate :or_newer do
    depends_on "llvm@21" => :build
  end

  on_sequoia do
    # https://developer.apple.com/documentation/xcode-release-notes/xcode-16_4-release-notes (149025504)
    depends_on xcode: ["16.4", :build]
  end

  def install
    # FIXME: Work around newer clang producing a broken binary
    if OS.mac? && MacOS.version >= :golden_gate
      ENV["CC"] = formula_opt_bin("llvm@21")/"clang"
      ENV["CXX"] = formula_opt_bin("llvm@21")/"clang++"
    end

    system "autoreconf", "--force", "--install", "--verbose" # TODO: if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "6 15 24", shell_output("#{bin}/apl --noSV --eval '+/ (3 3⍴1 2 3 4 5 6 7 8 9)'").strip
  end
end
