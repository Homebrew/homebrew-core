class Coreutils < Formula
  desc "GNU File, Shell, and Text utilities"
  homepage "https://www.gnu.org/software/coreutils"
  url "https://ftp.gnu.org/gnu/coreutils/coreutils-8.32.tar.xz"
  mirror "https://ftpmirror.gnu.org/coreutils/coreutils-8.32.tar.xz"
  sha256 "4458d8de7849df44ccab15e16b1548b285224dbba5f08fac070c1c0e0bcc4cfa"

  bottle do
    sha256 "67a4452d75a1882bd7fb977b384204edfa2758276d66290e595487922368e093" => :catalina
    sha256 "5da6cb9dbc0a8144480dde2fb78eb0a5a1710490afc3697174f7e261ec69763f" => :mojave
    sha256 "caa8cd8965727d0e805eccdc3e306cd0599720cdd0d5417cfcca03bead670663" => :high_sierra
  end

  head do
    url "https://git.savannah.gnu.org/git/coreutils.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "gettext" => :build
    depends_on "texinfo" => :build
    depends_on "wget" => :build
    depends_on "xz" => :build
  end

  conflicts_with "aardvark_shell_utils", :because => "both install `realpath` binaries"
  conflicts_with "b2sum", :because => "both install `b2sum` binaries"
  conflicts_with "ganglia", :because => "both install `gstat` binaries"
  conflicts_with "gegl", :because => "both install `gcut` binaries"
  conflicts_with "idutils", :because => "both install `gid` and `gid.1`"
  conflicts_with "md5sha1sum", :because => "both install `md5sum` and `sha1sum` binaries"
  conflicts_with "truncate", :because => "both install `truncate` binaries"

  def install
    system "./bootstrap" if build.head?

    args = %W[
      --prefix=#{prefix}
      --program-prefix=g
      --without-gmp
    ]

    # Work around a gnulib issue with macOS Catalina
    args << "gl_cv_func_ftello_works=yes"

    system "./configure", *args
    system "make", "install"

    # Symlink all commands into libexec/gnubin without the 'g' prefix
    coreutils_filenames(bin).each do |cmd|
      (libexec/"gnubin").install_symlink bin/"g#{cmd}" => cmd
    end
    # Symlink all man(1) pages into libexec/gnuman without the 'g' prefix
    coreutils_filenames(man1).each do |cmd|
      (libexec/"gnuman"/"man1").install_symlink man1/"g#{cmd}" => cmd
    end
    libexec.install_symlink "gnuman" => "man"

    # Symlink non-conflicting binaries
    no_conflict = %w[
      b2sum base32 chcon hostid md5sum nproc numfmt pinky ptx realpath runcon
      sha1sum sha224sum sha256sum sha384sum sha512sum shred shuf stdbuf tac timeout truncate
    ]
    no_conflict.each do |cmd|
      bin.install_symlink "g#{cmd}" => cmd
      man1.install_symlink "g#{cmd}.1" => "#{cmd}.1"
    end
  end

  def caveats; <<~EOS
    Commands also provided by macOS have been installed with the prefix "g".
    If you need to use these commands with their normal names, you
    can add a "gnubin" directory to your PATH from your bashrc like:
      PATH="#{opt_libexec}/gnubin:$PATH"
  EOS
  end

  def coreutils_filenames(dir)
    filenames = []
    dir.find do |path|
      next if path.directory? || path.basename.to_s == ".DS_Store"

      filenames << path.basename.to_s.sub(/^g/, "")
    end
    filenames.sort
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system bin/"gsha1sum", "-c", "test.sha1"
    system bin/"gln", "-f", "test", "test.sha1"
  end
end
