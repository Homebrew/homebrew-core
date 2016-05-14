class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://fishshell.com/files/2.2.0/fish-2.2.0.tar.gz"
  sha256 "a76339fd14ce2ec229283c53e805faac48c3e99d9e3ede9d82c0554acfc7b77a"

  bottle do
    revision 2
    sha256 "7bbc7e9901d1d3f8b15e6515de0dc3d7557e7e85a44ae0195172bd3c17120734" => :el_capitan
    sha256 "bf5af0e1a9179e8d5fcd9e945ce3fbfd44fa4ed86933375bc8ac2f0775074351" => :yosemite
    sha256 "39b820ee1cf8bffac46add0da2bdedd0a73ac5ce06c6f9a7e6d609aebef28dd2" => :mavericks
  end

  devel do
    url "https://github.com/fish-shell/fish-shell/releases/download/2.3b2/fish-2.3b2.tar.gz"
    sha256 "2b9342e7d5baf163e7384ea8f1270b8cdc06b19c8602e3c01546cc11d4337de9"

    depends_on "autoconf" => :build
    depends_on "doxygen" => :build
    depends_on "pcre2"
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "doxygen" => :build
    depends_on "pcre2"
  end

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

    If you are upgrading from an older version of fish, you should now run:
      killall fishd
    to terminate the outdated fish daemon.
    EOS
  end

  test do
    system "#{bin}/fish", "-c", "echo"
  end
end
