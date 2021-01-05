class Coreutils < Formula
  desc "GNU File, Shell, and Text utilities"
  homepage "https://www.gnu.org/software/coreutils"
  url "https://ftp.gnu.org/gnu/coreutils/coreutils-8.32.tar.xz"
  mirror "https://ftpmirror.gnu.org/coreutils/coreutils-8.32.tar.xz"
  sha256 "4458d8de7849df44ccab15e16b1548b285224dbba5f08fac070c1c0e0bcc4cfa"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    rebuild 1
    sha256 "ce8e32b05a59a6a7f2bd58544ff96902164780edc2a4804a1d97e11f28bc6cb6" => :big_sur
    sha256 "4f638cca6a59e708425aedaeea3c61fd84a69bde69833512429c206ac31dcf21" => :arm64_big_sur
    sha256 "f40ba727ec1bb54300c7c79804f410a62341b63f3fba41d78ef34e5d369fe9fc" => :catalina
    sha256 "91cd269ea5eff54a3074e0c3cd0995911c5989a4eb87a3c27b17a765c48f494e" => :mojave
    sha256 "25c71d9d9a156cc8dfaa52b35dad1f9d49df55e97748fb5ab9522f65aeed4dca" => :high_sierra
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

  uses_from_macos "gperf" => :build

  conflicts_with "aardvark_shell_utils", because: "both install `realpath` binaries"
  conflicts_with "b2sum", because: "both install `b2sum` binaries"
  conflicts_with "ganglia", because: "both install `gstat` binaries"
  conflicts_with "gegl", because: "both install `gcut` binaries"
  conflicts_with "idutils", because: "both install `gid` and `gid.1`"
  conflicts_with "md5sha1sum", because: "both install `md5sum` and `sha1sum` binaries"
  conflicts_with "truncate", because: "both install `truncate` binaries"
  conflicts_with "uutils-coreutils", because: "coreutils and uutils-coreutils install the same binaries"

  def install
    system "./bootstrap" if build.head?

    args = %W[
      --prefix=#{prefix}
      --program-prefix=g
      --without-gmp
    ]

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

  def caveats
    <<~EOS
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
