class GnuChess < Formula
  desc "Chess-playing program"
  homepage "https://www.gnu.org/software/chess/"
  url "https://ftp.gnu.org/gnu/chess/gnuchess-6.2.11.tar.gz"
  mirror "https://ftpmirror.gnu.org/chess/gnuchess-6.2.11.tar.gz"
  sha256 "d81140eea5c69d14b0cfb63816d4b4c9e18fba51f5267de5b1539f468939e9bd"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/href=.*?gnuchess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "42cd71a3f878830a2f20357cafb8c187286449b61554ee40a39e912eb875191a"
    sha256 arm64_sonoma:  "bc42a14400312b8a5a4bdd3b911c597205168f82cf5434250e96ed26cb94e157"
    sha256 arm64_ventura: "e0b50d39c42948e951377dba087745bc9800a742f5c0661cd962f9ef5c0ca795"
    sha256 sonoma:        "7feace56b47c9af020b6ebd88accc58e9a60acafb704fda5f8f3e34c5a5bc33e"
    sha256 ventura:       "77ced1bf8ab64d6c3e30aece47587d1bed8dbd123e742356f495d1411b0ef58a"
    sha256 arm64_linux:   "6b2bdd2733793500bafa854af6c7d64cf7ffd2db1f0b833ae758da19af958b60"
    sha256 x86_64_linux:  "1872f4bfa7445271a190bc1a7392c440e31874f09bb71428d9a8b061a0ad73e1"
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

    livecheck do
      url "https://ftp.gnu.org/gnu/chess/"
      regex(/href=.*?book[._-]v?(\d+(?:\.\d+)+\.pgn)/i)
    end
  end

  def install
    #  Fix "install-sh: Permission denied" issue
    chmod "+x", "install-sh"

    if build.head?
      system "autoreconf", "--force", "--install", "--verbose"
      chmod 0755, "install-sh"
    end

    system "./configure", *std_configure_args
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
