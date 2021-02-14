class GnuTar < Formula
  desc "GNU version of the tar archiving utility"
  homepage "https://www.gnu.org/software/tar/"
  url "https://ftp.gnu.org/gnu/tar/tar-1.34.tar.gz"
  mirror "https://ftpmirror.gnu.org/tar/tar-1.34.tar.gz"
  sha256 "03d908cf5768cfe6b7ad588c921c6ed21acabfb2b79b788d1330453507647aed"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "561f31d09837edf9398d73b0843010b4154b209196106df07cff06624e3df746"
    sha256 big_sur:       "ae7e03fc22f5e216f8dfb1aae1822595e5c11f9c78b06e1623577a8d76bc8d75"
    sha256 catalina:      "906c7a5265feb825505d1fe0ca563fe03f941f8d9d5487c83a90c0eade960d2b"
    sha256 mojave:        "057667a5bc2671beb8371b4da25b576167de95538c2a2e5cea9c16c76e14a20d"
  end

  head do
    url "https://git.savannah.gnu.org/git/tar.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  on_linux do
    conflicts_with "libarchive", because: "both install `tar` binaries"
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
