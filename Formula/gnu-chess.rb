class GnuChess < Formula
  desc "GNU Chess"
  homepage "https://www.gnu.org/software/chess/"
  url "https://ftp.gnu.org/gnu/chess/gnuchess-6.2.5.tar.gz"
  mirror "https://ftpmirror.gnu.org/chess/gnuchess-6.2.5.tar.gz"
  sha256 "9a99e963355706cab32099d140b698eda9de164ebce40a5420b1b9772dd04802"

  bottle do
    sha256 "959a8572f13e8ee41b20ae8dcfbd13671bf6a369f9d52e36c6070708659a6720" => :mojave
    sha256 "86d69dd816e2c3f4955c7f2af73df5a086c15879cde479f7657b9d2503c9c2b5" => :high_sierra
    sha256 "1a741b2a6de01917968ed8074bd6f52153589d3269f833feebba819df80379ef" => :sierra
    sha256 "f2e4587d4a42dbe78a4f7ec70fe5cfa54d46f93bad4a275c4759caa36cdc6688" => :el_capitan
    sha256 "328ac0deafb88bcfaf23c8ef54d483f3f00ebd2f2e3dbe44f3205636a5f8db1e" => :yosemite
  end

  head do
    url "https://svn.savannah.gnu.org/svn/chess/trunk"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "help2man" => :build
    depends_on "gettext"
  end

  option "with-book", "Download the opening book (~25MB)"

  depends_on "readline"

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
    def caveats; <<~EOS
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
