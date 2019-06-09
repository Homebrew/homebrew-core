class Mdk < Formula
  desc "GNU MIX development kit"
  homepage "https://www.gnu.org/software/mdk/mdk.html"
  url "https://ftp.gnu.org/gnu/mdk/v1.2.10/mdk-1.2.10.tar.gz"
  mirror "https://ftpmirror.gnu.org/mdk/v1.2.10/mdk-1.2.10.tar.gz"
  sha256 "b0f4323a607a3346769499b00fdd6d4748af5a61dd8a24511867ef5d96c08ce7"

  bottle do
    sha256 "906b2b508a0fccb27e86679b6a319598a9ed54f1407fe82d7d8f869cd217dd47" => :mojave
    sha256 "527f41bede7e5d517736044f1e7382882610f50364e91cb46ac6beacac53a67b" => :high_sierra
    sha256 "5db2d875c0ef2d23a91bff4bdcc7c40fc6ea82cb25d469d7a3665f53ffe8f483" => :sierra
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
