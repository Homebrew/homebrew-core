class GnuChess < Formula
  desc "GNU Chess"
  homepage "https://www.gnu.org/software/chess/"
  url "https://ftp.gnu.org/gnu/chess/gnuchess-6.2.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/chess/gnuchess-6.2.4.tar.gz"
  sha256 "3c425c0264f253fc5cc2ba969abe667d77703c728770bd4b23c456cbe5e082ef"

  bottle do
    sha256 "986750bf4784a983b5b9cdb41ebaecea3df181755bdd3b9925a06521fd9ebc07" => :sierra
    sha256 "8251ba46089e98ab4155c610e693026c7830312284cd30d6929acf1110b5cde9" => :el_capitan
    sha256 "0b2a3d6580b8b96e2dbd3b34d499f0143622b8d1757e2a72b4c43617ccd2d321" => :yosemite
  end

  head do
    url "https://svn.savannah.gnu.org/svn/chess/trunk"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "help2man" => :build
    depends_on "gettext"
  end

  option "with-book", "Download the opening book (~25MB)"

  resource "book" do
    url "https://ftp.gnu.org/gnu/chess/book_1.02.pgn.gz"
    sha256 "deac77edb061a59249a19deb03da349cae051e52527a6cb5af808d9398d32d44"
  end

  def install
    if build.head?
      system "autoreconf", "--install"
      chmod 0755, "install-sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    if build.with? "book"
      resource("book").stage do
        doc.install "book_1.02.pgn"
      end
    end
  end

  if build.with? "book"
    def caveats; <<-EOS.undent
      This formula also downloads the additional opening book.  The
      opening book is a PGN file located in #{doc} that can be added
      using gnuchess commands.
    EOS
    end
  end

  test do
    assert_equal "GNU Chess #{version}", shell_output("#{bin}/gnuchess --version").chomp
  end
end
