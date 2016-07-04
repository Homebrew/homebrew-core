class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://fishshell.com/files/2.3.1/fish-2.3.1.tar.gz"
  mirror "https://github.com/fish-shell/fish-shell/releases/download/2.3.1/fish-2.3.1.tar.gz"
  sha256 "328acad35d131c94118c1e187ff3689300ba757c4469c8cc1eaa994789b98664"

  bottle do
    sha256 "99462c8b9fc844882b8877f2b016823ce7c9e54dd89d532e13ce9e3af90558d4" => :el_capitan
    sha256 "30254c4c5bd3f2c6df4da5f805d8023f867b3ac0b5e3ed6557d864db102ff6f7" => :yosemite
    sha256 "c91612a4f4e6e99bb81a0e699adce007c48a175e73dde5af239ae7ee41f3af90" => :mavericks
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "doxygen" => :build
  end

  depends_on "pcre2"

  def install
    system "autoconf" if build.head? || build.devel?
    # In Homebrew's 'superenv' sed's path will be incompatible, so
    # the correct path is passed into configure here.
    system "./configure", "--prefix=#{prefix}", "SED=/usr/bin/sed"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    You will need to add:
      #{HOMEBREW_PREFIX}/bin/fish
    to /etc/shells.

    Then run:
      chsh -s #{HOMEBREW_PREFIX}/bin/fish
    to make fish your default shell.
    EOS
  end

  test do
    system "#{bin}/fish", "-c", "echo"
  end
end
