class Coreutils < Formula
  desc "GNU File, Shell, and Text utilities"
  homepage "https://www.gnu.org/software/coreutils"
  url "https://ftp.gnu.org/gnu/coreutils/coreutils-8.31.tar.xz"
  mirror "https://ftpmirror.gnu.org/coreutils/coreutils-8.31.tar.xz"
  sha256 "ff7a9c918edce6b4f4b2725e3f9b37b0c4d193531cac49a48b56c4d0d3a9e9fd"

  bottle do
    rebuild 1
    sha256 "7262e4c76483ea796454db828c25955be1e6b2bc8e056ba1dd6e92bfe1118da5" => :catalina
    sha256 "05ae58c26a53c2dfa2d9d45943b9d21753eea59609f0a48caa59713d6f6392d7" => :mojave
    sha256 "5cba7394f1995fad0f6215a7618f65983dcf84b93b076af18d09354051320fb2" => :high_sierra
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
