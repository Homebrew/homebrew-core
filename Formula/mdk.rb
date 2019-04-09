class Mdk < Formula
  desc "GNU MIX development kit"
  homepage "https://www.gnu.org/software/mdk/mdk.html"
  url "https://ftp.gnu.org/gnu/mdk/v1.2.9/mdk-1.2.9.tar.gz"
  mirror "https://ftpmirror.gnu.org/mdk/v1.2.9/mdk-1.2.9.tar.gz"
  sha256 "6c265ddd7436925208513b155e7955e5a88c158cddda72c32714ccf5f3e74430"
  revision 4

  bottle do
    sha256 "a13810f7246ea0adcd01a507c97e5041d64aae92cafcc2a6d26eeafbd5b8732b" => :mojave
    sha256 "17b4bb66066acdc77836431aa0aa57d456aceaa097a1758ea7495d52bca49809" => :high_sierra
    sha256 "0021a786577ff2eb6b220939a19e0a80f0f8546022d8c35eccb719e72bff2378" => :sierra
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
