class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/2.7.0/fish-2.7.0.tar.gz"
  mirror "https://fishshell.com/files/2.7.0/fish-2.7.0.tar.gz"
  sha256 "3a76b7cae92f9f88863c35c832d2427fb66082f98e92a02203dc900b8fa87bcb"

  bottle do
    sha256 "f763473b4f907d5869565c210a94760753f27f0d2a0d2ae203499a6f0041f86e" => :high_sierra
    sha256 "c40e50463f8c2c3f6a7112117aead0cd367dcabd460f5c477cd84eb90f7ca9fa" => :sierra
    sha256 "0e96903e4fdd6a58dfd9e96a920e33056919f952de2dfecd9e4122db5a29b036" => :el_capitan
    sha256 "b9ce33c6f9066e4f72a8e2870f1113cf7c89d7975fd77be5a97358398f30221b" => :yosemite
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
