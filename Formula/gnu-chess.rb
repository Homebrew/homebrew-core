class GnuChess < Formula
  desc "GNU Chess"
  homepage "https://www.gnu.org/software/chess/"
  url "https://ftp.gnu.org/gnu/chess/gnuchess-6.2.5.tar.gz"
  mirror "https://ftpmirror.gnu.org/chess/gnuchess-6.2.5.tar.gz"
  sha256 "9a99e963355706cab32099d140b698eda9de164ebce40a5420b1b9772dd04802"
  revision 1

  bottle do
    rebuild 1
    sha256 "5000f5a62f1a1db38266d8906bc1e913fb7338cbff343e311db3528526a07be1" => :mojave
    sha256 "c92625455a565c0461225f5621eab5b35975dec37e24f56a474558fbef842424" => :high_sierra
    sha256 "c3be8288c580125622a653cb2092234ee3d07feb01be458ed24ac331612c103a" => :sierra
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

  def caveats; <<~EOS
    This formula also downloads the additional opening book.  The
    opening book is a PGN file located in #{doc} that can be added
    using gnuchess commands.
  EOS
  end

  test do
    assert_equal "GNU Chess #{version}", shell_output("#{bin}/gnuchess --version").chomp
  end
end
