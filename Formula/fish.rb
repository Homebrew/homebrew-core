class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"

  stable do
    url "https://github.com/fish-shell/fish-shell/releases/download/2.6.0/fish-2.6.0.tar.gz"
    mirror "https://fishshell.com/files/2.6.0/fish-2.6.0.tar.gz"
    sha256 "7ee5bbd671c73e5323778982109241685d58a836e52013e18ee5d9f2e638fdfb"
  end

  bottle do
    sha256 "d012c7b4d1dce5e766fe9990f19ec7ac0ae5c4a69fc15e01cf123e8f88c1910f" => :sierra
    sha256 "2b28972cc66472fa11782b344c64b51569a43d0fd8b098ad4b787a1c79aca2b1" => :el_capitan
    sha256 "385def41fe9c29237b7319218ae0184f64b6b750e525f92ee6913cf20c478a69" => :yosemite
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "doxygen" => :build
  end

  depends_on "pcre2"

  def install
    system "autoreconf", "--no-recursive" if build.head?

    # In Homebrew's 'superenv' sed's path will be incompatible, so
    # the correct path is passed into configure here.
    args = %W[
      --prefix=#{prefix}
      --with-extra-functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d
      --with-extra-completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d
      --with-extra-confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d
      SED=/usr/bin/sed
    ]
    system "./configure", *args
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

  def post_install
    (pkgshare/"vendor_functions.d").mkpath
    (pkgshare/"vendor_completions.d").mkpath
    (pkgshare/"vendor_conf.d").mkpath
  end

  test do
    system "#{bin}/fish", "-c", "echo"
  end
end
