class GnuChess < Formula
  desc "Chess-playing program"
  homepage "https://www.gnu.org/software/chess/"
  url "https://ftp.gnu.org/gnu/chess/gnuchess-6.2.7.tar.gz"
  mirror "https://ftpmirror.gnu.org/chess/gnuchess-6.2.7.tar.gz"
  sha256 "e536675a61abe82e61b919f6b786755441d9fcd4c21e1c82fb9e5340dd229846"
  license "GPL-3.0"

  livecheck do
    url :stable
    regex(/href=.*?gnuchess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "85423112485c7dbe474c99c93008b8a7a7a8c9a9737bbda3e372fde8674cbef1" => :catalina
    sha256 "4bc514e190844faa459fbbc204c7bdd4699cb6cd09011811ae0999429343f0da" => :mojave
    sha256 "81883d1506513bdb4feff2617b492237aef06a2f17f3bd4eb81e68142c4d73af" => :high_sierra
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
