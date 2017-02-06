class GnuChess < Formula
  desc "GNU Chess"
  homepage "https://www.gnu.org/software/chess/"
  url "https://ftpmirror.gnu.org/chess/gnuchess-6.2.4.tar.gz"
  mirror "https://ftp.gnu.org/gnu/chess/gnuchess-6.2.4.tar.gz"
  sha256 "3c425c0264f253fc5cc2ba969abe667d77703c728770bd4b23c456cbe5e082ef"

  bottle do
    sha256 "411c317415947009b6049a01eba5f982b3a490f6bf55e11666af6e6c8b8ffe18" => :sierra
    sha256 "65ee081879182d9ebd12eef9d737bc12ad22247ff27ecd339ecb2f76e1434cbe" => :el_capitan
    sha256 "20c1c10b54746fb09eeb0101b014d39fb6196b0668ed5e6e9b9acd0b6488b970" => :yosemite
  end

  head do
    url "svn://svn.savannah.gnu.org/chess/trunk"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "help2man" => :build
    depends_on "gettext"
  end

  option "with-book", "Download the opening book (~25MB)"

  resource "book" do
    url "https://ftpmirror.gnu.org/chess/book_1.02.pgn.gz"
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
