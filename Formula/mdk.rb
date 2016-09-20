class Mdk < Formula
  desc "GNU MIX development kit"
  homepage "https://www.gnu.org/software/mdk/mdk.html"
  url "https://ftpmirror.gnu.org/mdk/v1.2.9/mdk-1.2.9.tar.gz"
  mirror "https://ftp.gnu.org/gnu/mdk/v1.2.9/mdk-1.2.9.tar.gz"
  sha256 "6c265ddd7436925208513b155e7955e5a88c158cddda72c32714ccf5f3e74430"
  revision 1

  bottle do
    sha256 "9e3290fb263592ecfcd5f11b4015536c40f676a2c31987c954f568b43c0998bd" => :el_capitan
    sha256 "95c93e5625b975cc85854467782a18116bde17e19fc94ae11e6dce6bdae0a44f" => :yosemite
    sha256 "eaab34ff8d2d73e08da0c3596fbee2eadc68cc269c1fe7b425b49f703348dcfa" => :mavericks
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
