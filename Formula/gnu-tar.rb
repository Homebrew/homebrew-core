class GnuTar < Formula
  desc "GNU version of the tar archiving utility"
  homepage "https://www.gnu.org/software/tar/"
  url "https://ftp.gnu.org/gnu/tar/tar-1.30.tar.gz"
  mirror "https://ftpmirror.gnu.org/tar/tar-1.30.tar.gz"
  sha256 "4725cc2c2f5a274b12b39d1f78b3545ec9ebb06a6e48e8845e1995ac8513b088"

  bottle do
    sha256 "20f2d3cad911cb885ac3760daa283d5fd709e570f8a97486e91a6f41a49183c8" => :high_sierra
    sha256 "d87139778146e9fe39f5db5dcf020c51a5a8ed7528987e31ecd2a2a36ab239e2" => :sierra
    sha256 "ba2d4a54ae4abf2520b816d19373ed0a8bd0bb0e894b271d98ee1c7eba51af16" => :el_capitan
    sha256 "cb0a9258bfeb0530540af1748b37a4fe79cf07ec5848e7bce48c47d51289bdb7" => :yosemite
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
