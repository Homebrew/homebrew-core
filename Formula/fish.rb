class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/2.7.0/fish-2.7.0.tar.gz"
  mirror "https://fishshell.com/files/2.7.0/fish-2.7.0.tar.gz"
  sha256 "3a76b7cae92f9f88863c35c832d2427fb66082f98e92a02203dc900b8fa87bcb"

  bottle do
    sha256 "affac16a396410a500241266dbbbd8752562c9b800d9e4f2ef8de279c6fdb6aa" => :high_sierra
    sha256 "335538a7ea7f9613474f7321af0a1d519b61b0fc4be97a1744a7ea7bef7ff7e3" => :sierra
    sha256 "463cfa8edc0603761f25e0ba4e49524f69a1d856263d370d1de5fb8698dd5ccf" => :el_capitan
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

  def caveats; <<~EOS
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
