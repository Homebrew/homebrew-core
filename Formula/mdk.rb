class Mdk < Formula
  desc "GNU MIX development kit"
  homepage "https://www.gnu.org/software/mdk/mdk.html"
  url "https://ftp.gnu.org/gnu/mdk/v1.2.10/mdk-1.2.10.tar.gz"
  mirror "https://ftpmirror.gnu.org/mdk/v1.2.10/mdk-1.2.10.tar.gz"
  sha256 "b0f4323a607a3346769499b00fdd6d4748af5a61dd8a24511867ef5d96c08ce7"
  revision 2

  bottle do
    sha256 "11d143b7ea88fb34427d08f9755bc62fb5129b577a7a2fcc813c3cacf4c7c644" => :catalina
    sha256 "344482a184e612e63d0839e0e254c1c27b44971dcf62dc4cba96fb45a5db4aaf" => :mojave
    sha256 "261bdee4241a6db4a361aca51bd4b052fc4686bd9f2ece6b24391c569c1c1558" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "flex"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "guile"
  depends_on "libglade"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
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
    system "#{bin}/mixasm", "hello"
    output = `#{bin}/mixvm -r hello`

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
