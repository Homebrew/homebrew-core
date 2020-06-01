class GnuChess < Formula
  desc "GNU Chess"
  homepage "https://www.gnu.org/software/chess/"
  url "https://ftp.gnu.org/gnu/chess/gnuchess-6.2.7.tar.gz"
  mirror "https://ftpmirror.gnu.org/chess/gnuchess-6.2.7.tar.gz"
  sha256 "e536675a61abe82e61b919f6b786755441d9fcd4c21e1c82fb9e5340dd229846"

  bottle do
    sha256 "205554eca1980a965a22d14a6d0ce23b2e31a76c9034131dd471269a71467baf" => :catalina
    sha256 "0207c9124aad69e97a1a980b2208c004b2ca56b5d93de92f125a50ecf135e7db" => :mojave
    sha256 "bce06477a41f092277fb22d4b546a41c36cb9057b176ee3e28df0866b426f619" => :high_sierra
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
