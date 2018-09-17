class GnuTar < Formula
  desc "GNU version of the tar archiving utility"
  homepage "https://www.gnu.org/software/tar/"
  url "https://ftp.gnu.org/gnu/tar/tar-1.30.tar.gz"
  mirror "https://ftpmirror.gnu.org/tar/tar-1.30.tar.gz"
  sha256 "4725cc2c2f5a274b12b39d1f78b3545ec9ebb06a6e48e8845e1995ac8513b088"

  bottle do
    sha256 "2a112e5b1a9c895ef51cb85d5ae0f02c9804ada9e9f55cbd8f698ec63b51c69b" => :mojave
    sha256 "ad87e1488b6d1a2db804c348abf05143b6b7310402c7928f725305c295599708" => :high_sierra
    sha256 "5a04574acb1ff235b2509e70cb207e6379a8c83191986131bba52717c328fc1b" => :sierra
    sha256 "1a559b78e6f1a6594b18a9ba2aa2e9828af2736aacc4aec07911fe7638e80e68" => :el_capitan
  end

  head do
    url "https://git.savannah.gnu.org/git/tar.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  option "with-default-names", "Do not prepend 'g' to the binary"

  def install
    # Work around unremovable, nested dirs bug that affects lots of
    # GNU projects. See:
    # https://github.com/Homebrew/homebrew/issues/45273
    # https://github.com/Homebrew/homebrew/issues/44993
    # This is thought to be an el_capitan bug:
    # https://lists.gnu.org/archive/html/bug-tar/2015-10/msg00017.html
    ENV["gl_cv_func_getcwd_abort_bug"] = "no" if MacOS.version == :el_capitan

    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
    args << "--program-prefix=g" if build.without? "default-names"

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"

    # Symlink the executable into libexec/gnubin as "tar"
    if build.without? "default-names"
      (libexec/"gnubin").install_symlink bin/"gtar" =>"tar"
      (libexec/"gnuman/man1").install_symlink man1/"gtar.1" => "tar.1"
    end
  end

  def caveats
    if build.without? "default-names" then <<~EOS
      gnu-tar has been installed as "gtar".

      If you really need to use it as "tar", you can add a "gnubin" directory
      to your PATH from your bashrc like:

          PATH="#{opt_libexec}/gnubin:$PATH"

      Additionally, you can access their man pages with normal names if you add
      the "gnuman" directory to your MANPATH from your bashrc as well:

          MANPATH="#{opt_libexec}/gnuman:$MANPATH"

    EOS
    end
  end

  test do
    tar = build.with?("default-names") ? bin/"tar" : bin/"gtar"
    (testpath/"test").write("test")
    system tar, "-czvf", "test.tar.gz", "test"
    assert_match /test/, shell_output("#{tar} -xOzf test.tar.gz")
  end
end
