class Mdk < Formula
  desc "GNU MIX development kit"
  homepage "https://www.gnu.org/software/mdk/mdk.html"
  url "https://ftpmirror.gnu.org/mdk/v1.2.9/mdk-1.2.9.tar.gz"
  mirror "https://ftp.gnu.org/gnu/mdk/v1.2.9/mdk-1.2.9.tar.gz"
  sha256 "6c265ddd7436925208513b155e7955e5a88c158cddda72c32714ccf5f3e74430"
  revision 1

  bottle do
    sha256 "9ba8df4910f272cdce34416cffb4d9b5ea27ab17a18c15a7a03b78e2c82bdde5" => :sierra
    sha256 "ec7f02653ee96c042c3699337c480cd986d6aef25c158cf4f5051dba53a4c586" => :el_capitan
    sha256 "9c51160fede51db605a8cf475dfc74b1733304ab2e8179c79a6973f73ec27669" => :yosemite
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "libglade"
  depends_on "glib"
  depends_on "flex"
  depends_on "guile"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"hello.mixal").write <<-EOS.undent
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
    system "#{bin}/mixasm", "hello"
    output = `#{bin}/mixvm -r hello`

    expected = <<-EOS.undent
      Program loaded. Start address: 1000
      Running ...
      MIXAL HELLO WORLDXXX
      ... done
    EOS
    expected = expected.gsub("XXX", " " *53)

    assert_equal expected, output
  end
end
