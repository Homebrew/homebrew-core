class GnuChess < Formula
  desc "Chess-playing program"
  homepage "https://www.gnu.org/software/chess/"
  url "https://ftp.gnu.org/gnu/chess/gnuchess-6.2.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/chess/gnuchess-6.2.8.tar.gz"
  sha256 "d50446cda8012240321da39cddbb4df4d08458a8d538a4738882814139583847"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/href=.*?gnuchess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "9f6f4e4be12a9b4a543077dfeff7220216c5b50076b3fe502452726654c588b3"
    sha256 big_sur:       "4049d5fe6c4ae97e9756faae5f8a25e4f20d2af9ae97999a79ffeb9fe4a0dc85"
    sha256 catalina:      "31f8d094109dfff455ac3ec6ccd46c5b109b105bd0a6f348778c4ff4469cb304"
    sha256 mojave:        "64398f15fb0e590834f9970a8eff17744e3f038b56709c7e54923181ddaa8934"
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
