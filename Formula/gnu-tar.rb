class GnuTar < Formula
  desc "GNU version of the tar archiving utility"
  homepage "https://www.gnu.org/software/tar/"
  url "https://ftp.gnu.org/gnu/tar/tar-1.33.tar.gz"
  mirror "https://ftpmirror.gnu.org/tar/tar-1.33.tar.gz"
  sha256 "7c77c427e8cce274d46a6325d45a55b08e13e2d2d0c9e6c0860a6d2b9589ff0e"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "952e5c4dd04ddab0c2678edf97f24c02f6dfde9f5d031a98fc269064197a0872" => :big_sur
    sha256 "8f452aa6fe50b5af78c9ecb0290051af2ae2f08f89d0634eac0f2e1d7eaa64b5" => :arm64_big_sur
    sha256 "158cb67ea9e02435d671013b4d0d7369822758d9f7ff400ce2512a03f2f7f4e4" => :catalina
    sha256 "1034894e78bb22b0fcf0c8114666d4dc3eb82345a5ca83797ca3bda367d998ac" => :mojave
    sha256 "3771cead286229786d9d92a7697bc6e0de576ec9cae1f881017884ceb3e24f17" => :high_sierra
  end

  head do
    url "https://git.savannah.gnu.org/git/tar.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  def install
    # Work around unremovable, nested dirs bug that affects lots of
    # GNU projects. See:
    # https://github.com/Homebrew/homebrew/issues/45273
    # https://github.com/Homebrew/homebrew/issues/44993
    # This is thought to be an el_capitan bug:
    # https://lists.gnu.org/archive/html/bug-tar/2015-10/msg00017.html
    ENV["gl_cv_func_getcwd_abort_bug"] = "no" if MacOS.version == :el_capitan

    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    on_macos do
      args << "--program-prefix=g"
    end
    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"

    on_macos do
      # Symlink the executable into libexec/gnubin as "tar"
      (libexec/"gnubin").install_symlink bin/"gtar" =>"tar"
      (libexec/"gnuman/man1").install_symlink man1/"gtar.1" => "tar.1"
    end

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        GNU "tar" has been installed as "gtar".
        If you need to use it as "tar", you can add a "gnubin" directory
        to your PATH from your bashrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    (testpath/"test").write("test")
    on_macos do
      system bin/"gtar", "-czvf", "test.tar.gz", "test"
      assert_match /test/, shell_output("#{bin}/gtar -xOzf test.tar.gz")
      assert_match /test/, shell_output("#{opt_libexec}/gnubin/tar -xOzf test.tar.gz")
    end

    on_linux do
      system bin/"tar", "-czvf", "test.tar.gz", "test"
      assert_match /test/, shell_output("#{bin}/tar -xOzf test.tar.gz")
    end
  end
end
