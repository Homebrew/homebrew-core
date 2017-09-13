class Mdk < Formula
  desc "GNU MIX development kit"
  homepage "https://www.gnu.org/software/mdk/mdk.html"
  url "https://ftp.gnu.org/gnu/mdk/v1.2.9/mdk-1.2.9.tar.gz"
  mirror "https://ftpmirror.gnu.org/mdk/v1.2.9/mdk-1.2.9.tar.gz"
  sha256 "6c265ddd7436925208513b155e7955e5a88c158cddda72c32714ccf5f3e74430"
  revision 2

  bottle do
    sha256 "f294500b0cce468da3b3420eed199ce6f7e50a6adfd582089a1d1f36080c4fbb" => :sierra
    sha256 "2f7d0012a3a4ccb69e4ca500e16f5059642ddebc79bbac2df08dd73385d8e9e9" => :el_capitan
    sha256 "264586d3518f0a1a5641c979471acf23860119d407c8efef608ae69e559a42cd" => :yosemite
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
    ENV["LANG"] = "en_US.UTF-8"

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
