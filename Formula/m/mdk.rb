class Mdk < Formula
  desc "GNU MIX development kit"
  homepage "https://www.gnu.org/software/mdk/mdk.html"
  url "https://ftp.gnu.org/gnu/mdk/v1.3.0/mdk-1.3.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/mdk/v1.3.0/mdk-1.3.0.tar.gz"
  sha256 "8b1e5dd7f47b738cb966ef717be92a501494d9ba6d87038f09e8fa29101b132e"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_sequoia:  "7f8f1976f4085fd2069b0e8e36c7b4dc939a9da53776d446c5bd00587c166ba7"
    sha256 arm64_sonoma:   "fd1a717d1a4c992880d8afd9217b46416521dbe7d4c87b6caf86efdc9e603bb7"
    sha256 arm64_ventura:  "916131e068d96db724db7c8fb50fa406dd2847ef028222b40a2c13bd2ee4d667"
    sha256 arm64_monterey: "82a2cadce9c1f29cd4d7b53ec2ca15b8382a964627219ed87f3cd75927f851b8"
    sha256 sonoma:         "af8fd1f81a41417af557691fc2cd065b7f4e9bca2f84110bca43a235c066eb0b"
    sha256 ventura:        "c2b79558a41c36b848cb8b9ef2500a82ee961c1c427a09a01fce486e5b9b2a06"
    sha256 monterey:       "90c9293131de5a4a7533cb6a1bc613cad2d9c1750833bde1fcd795cbbc7923ae"
    sha256 arm64_linux:    "60f4588de7ace79258c78dbbeff43ed39e97a0f3fc8dde564a88e8863ac9d05f"
    sha256 x86_64_linux:   "baf283b8cdb2d96c284ced6a347f7754132b5f696663552bda24d45ca9ca2ca5"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "flex"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "guile"
  depends_on "pango"
  depends_on "readline"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "bdw-gc"
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
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
