class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://fishshell.com/files/2.3.0/fish-2.3.0.tar.gz"
  mirror "https://github.com/fish-shell/fish-shell/releases/download/2.3.0/fish-2.3.0.tar.gz"
  sha256 "912bac47552b1aa0d483a39ade330356632586a8f726c0e805b46d45cfad54e5"

  bottle do
    revision 2
    sha256 "7bbc7e9901d1d3f8b15e6515de0dc3d7557e7e85a44ae0195172bd3c17120734" => :el_capitan
    sha256 "bf5af0e1a9179e8d5fcd9e945ce3fbfd44fa4ed86933375bc8ac2f0775074351" => :yosemite
    sha256 "39b820ee1cf8bffac46add0da2bdedd0a73ac5ce06c6f9a7e6d609aebef28dd2" => :mavericks
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

    If you are upgrading from an older version of fish, you should now run:
      killall fishd
    to terminate the outdated fish daemon.
    EOS
  end

  test do
    system "#{bin}/fish", "-c", "echo"
  end
end
