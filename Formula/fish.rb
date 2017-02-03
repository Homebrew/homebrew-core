class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"

  stable do
    url "https://fishshell.com/files/2.5.0/fish-2.5.0.tar.gz"
    mirror "https://github.com/fish-shell/fish-shell/releases/download/2.5.0/fish-2.5.0.tar.gz"
    sha256 "f8c0edadca2de379ccf305aeace660a9255fa2180c72e85e97705a24c256b2a5"
  end

  bottle do
    sha256 "0935641436db91447c2ebfa271df82a39ae0be428044a59aab9a41992d12e57f" => :sierra
    sha256 "1f9faaa90bb1200db70221c8c5a79bcb524dd4b09808276f93315353b06af493" => :el_capitan
    sha256 "36f144331928e5a9dcd612b303457ae6b4ae2d6afb17b873b709c1f80369d359" => :yosemite
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
