class GnuTar < Formula
  desc "GNU version of the tar archiving utility"
  homepage "https://www.gnu.org/software/tar/"
  url "http://ftpmirror.gnu.org/tar/tar-1.29.tar.gz"
  mirror "https://ftp.gnu.org/gnu/tar/tar-1.29.tar.gz"
  sha256 "cae466e6e58c7292355e7080248f244db3a4cf755f33f4fa25ca7f9a7ed09af0"

  bottle do
    revision 4
    sha256 "006f9aba7b70361c01666a0775027457265646bdd4d05a4c6fc1b0d9268af8a8" => :el_capitan
    sha256 "7a32439d8e25984e4737ab74e1ee15a03f0cfc1455f9940f98beafe8609d97e8" => :yosemite
    sha256 "b51eee5840990c2fc46ea887d9efd9c06fd92946bd39b8e4c124c4da40873be3" => :mavericks
  end

  option "with-default-names", "Do not prepend 'g' to the binary"

  def install
    # Work around unremovable, nested dirs bug that affects lots of
    # GNU projects. See:
    # https://github.com/Homebrew/homebrew/issues/45273
    # https://github.com/Homebrew/homebrew/issues/44993
    # This is thought to be an el_capitan bug:
    # https://lists.gnu.org/archive/html/bug-tar/2015-10/msg00017.html
    if MacOS.version == :el_capitan
      ENV["gl_cv_func_getcwd_abort_bug"] = "no"
    end

    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"

    # Symlink the executable into libexec/gnubin as "tar"
    if build.without? "default-names"
      (libexec/"gnubin").install_symlink bin/"gtar" =>"tar"
      (libexec/"gnuman/man1").install_symlink man1/"gtar.1" => "tar.1"
    end
  end

  def caveats
    if build.without? "default-names" then <<-EOS.undent
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
