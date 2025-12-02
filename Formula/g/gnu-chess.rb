class GnuChess < Formula
  desc "Chess-playing program"
  homepage "https://www.gnu.org/software/chess/"
  url "https://ftpmirror.gnu.org/gnu/chess/gnuchess-6.3.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/chess/gnuchess-6.3.0.tar.gz"
  sha256 "0b37bec2098c2ad695b7443e5d7944dc6dc8284f8d01fcc30bdb94dd033ca23a"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/href=.*?gnuchess[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "df22ed67f466752c4e166eff301bb7632a3ea16af817b41a00078d2a1ea0cc78"
    sha256 arm64_sequoia: "73f1c20678a4342e457f1c56ba5e08163a559f81355b3fc58b7fb972760436f6"
    sha256 arm64_sonoma:  "6d90980d6d03d4531f6c5e647a8e10fd0322684f3d2ef58c87af5f7d9aff98dd"
    sha256 arm64_ventura: "550f52039857be7104c04436da80454c85ea7c08792e5b42a0623413b220953f"
    sha256 sonoma:        "d803b6892e888d463f2af6004ebc4b40a2735d5d24b90710cf41030d40f46e9a"
    sha256 ventura:       "46b344c0ae3e5b3507678f9d5a1814927a349487a28095f4b23fa854eaa76571"
    sha256 arm64_linux:   "5b309d410c55a15466f49fdc14dd4284589554f2494ab582fd26eb76fc5d1162"
    sha256 x86_64_linux:  "514caae489b6d6093b791d055c0dbd571863413c1927ebd0c82a4aebfd7c7553"
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
    url "https://ftpmirror.gnu.org/gnu/chess/book_1.02.pgn.gz"
    sha256 "deac77edb061a59249a19deb03da349cae051e52527a6cb5af808d9398d32d44"

    livecheck do
      url "https://ftpmirror.gnu.org/gnu/chess/"
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
    assert_match "GNU Chess #{version}", shell_output("#{bin}/gnuchess --version")
  end
end
