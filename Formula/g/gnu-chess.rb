class GnuChess < Formula
  desc "Chess-playing program"
  homepage "https://www.gnu.org/software/chess/"
  url "https://ftp.gnu.org/gnu/chess/gnuchess-6.2.9.tar.gz"
  mirror "https://ftpmirror.gnu.org/chess/gnuchess-6.2.9.tar.gz"
  sha256 "ddfcc20bdd756900a9ab6c42c7daf90a2893bf7f19ce347420ce36baebc41890"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/href=.*?gnuchess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "86f7885d980763cbe4543012b9f9f55b8cf3065da939d06bb35dd9b0f94272de"
    sha256 arm64_monterey: "b03db46e113c63c8d141181ca6f89626414827a3d0aa15dc88e7cb72f2fcaf69"
    sha256 arm64_big_sur:  "8e356eccb6a541eee641342bc7f923b35271fd51c094ca6b83e8abdecd7226a1"
    sha256 ventura:        "1d5ac1a6260b684188c024f2bdb4e6838ce78d442f42fa59ebf2af1b00d18123"
    sha256 monterey:       "7e1eed30943db3dc80910b5f10ae6df5b65354e65748fff524dba044ea495da8"
    sha256 big_sur:        "11997b7b97ab58380f07e491fc9b75649f52ab6d7edfdfbdbf025a3a12d81d3a"
    sha256 catalina:       "d3dcc4bec287a4b09dbb0dba0f7fc51943812fed43eeda21a5f3d314ae77dbf6"
    sha256 mojave:         "03d9103b7fbbfeaf487d3b6dbac291eaacd51299052b62ddd3564eaedc513f08"
    sha256 x86_64_linux:   "ef91217fa368cd712df9a7c4c6def92eeb5a26b37d5c0e9ee51e13a3ab7cca26"
  end

  head do
    url "https://svn.savannah.gnu.org/svn/chess/trunk"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "help2man" => :build
    depends_on "gettext"
  end

  depends_on "readline"

  resource "book" do
    url "https://ftp.gnu.org/gnu/chess/book_1.02.pgn.gz"
    sha256 "deac77edb061a59249a19deb03da349cae051e52527a6cb5af808d9398d32d44"
  end

  def install
    #  Fix "install-sh: Permission denied" issue
    chmod "+x", "install-sh"

    if build.head?
      system "autoreconf", "--install"
      chmod 0755, "install-sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    resource("book").stage do
      doc.install "book_1.02.pgn"
    end
  end

  def caveats
    <<~EOS
      This formula also downloads the additional opening book.  The
      opening book is a PGN file located in #{doc} that can be added
      using gnuchess commands.
    EOS
  end

  test do
    assert_equal "GNU Chess #{version}", shell_output("#{bin}/gnuchess --version").chomp
  end
end
