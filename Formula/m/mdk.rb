class Mdk < Formula
  desc "GNU MIX development kit"
  homepage "https://www.gnu.org/software/mdk/mdk.html"
  url "https://ftpmirror.gnu.org/gnu/mdk/v1.3.1/mdk-1.3.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/mdk/v1.3.1/mdk-1.3.1.tar.gz"
  sha256 "ebb963938c688c150ff6aaedc29f30d09020a1e31d55b30c2101f08773516d19"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_tahoe:   "7826d050643554b4fd5b996d6d435b817f5afc3d377838c17603134ee397387f"
    sha256 arm64_sequoia: "ad86e88bcdb7d4a02549a80945c2bf96d74c7d95ae55d3d25a654c8ce74d09bc"
    sha256 arm64_sonoma:  "00a6b39d4f40ce43f02096c41759d5fc9603f8410e310c4151ed4ac9eb27de28"
    sha256 sonoma:        "be057e6d7aa944047f2e2f1708dddd6bffba1fa6c937264c0a5065e11b1c1bf0"
    sha256 arm64_linux:   "e6ec02348519a896a3cd23987ec812358ede91138da903dcfd6cad75a2cdb1ce"
    sha256 x86_64_linux:  "11178d7f888d4b955959d12ede795d08d2af47aca254caaa3a9769b39056cdab"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
  depends_on "bdw-gc"
  depends_on "cairo"
  depends_on "flex"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "guile"
  depends_on "harfbuzz"
  depends_on "pango"
  depends_on "readline"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1599

    depends_on "gettext"
  end

  on_linux do
    depends_on "ncurses"
  end

  fails_with :clang do
    build 1599
    cause "Requires relaxed variadic args"
  end

  fails_with :gcc do
    version "11"
    cause "Requires relaxed variadic args"
  end

  def install
    ENV.llvm_clang if DevelopmentTools.clang_build_version <= 1599
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "CFLAGS=-std=gnu2x"
    system "make", "install"
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"

    (testpath/"hello.mixal").write <<~EOS
      *                                                        (1)
      * hello.mixal: say "hello world" in MIXAL                (2)
      *                                                        (3)
      * label ins    operand     comment                       (4)
      TERM    EQU    19          the MIX console device number (5)
              ORIG   1000        start address                 (6)
      START   OUT    MSG(TERM)   output data at address MSG    (7)
              HLT                halt execution                (8)
      MSG     ALF    "MIXAL"                                   (9)
              ALF    " HELL"                                   (10)
              ALF    "O WOR"                                   (11)
              ALF    "LD"                                      (12)
              END    START       end of the program            (13)
    EOS
    system bin/"mixasm", "hello"
    output = shell_output("#{bin}/mixvm -r hello")

    expected = <<~EOS
      Program loaded. Start address: 1000
      Running ...
      MIXAL HELLO WORLDXXX
      ... done
    EOS
    expected = expected.gsub("XXX", " " *53)

    assert_equal expected, output
  end
end
