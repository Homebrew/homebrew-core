class MakeGuile < Formula
  desc "Utility for directing compilation with Guile support enabled"
  homepage "https://www.gnu.org/software/make/"
  url "https://ftpmirror.gnu.org/gnu/make/make-4.4.1.tar.lz"
  mirror "https://ftp.gnu.org/gnu/make/make-4.4.1.tar.lz"
  sha256 "8814ba072182b605d156d7589c19a43b89fc58ea479b9355146160946f8cf6e9"
  license "GPL-3.0-only"

  head do
    url "https://git.savannah.gnu.org/git/make.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build # for autopoint
    depends_on "libtool" => :build
    depends_on "texinfo" => :build
    depends_on "wget" => :build # used by autopull

    uses_from_macos "m4" => :build

    fails_with :clang # fails with invalid arguments sent to compiler
  end

  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "guile"

  def install
    if build.head?
      system "./autopull.sh" # downloads gnulib files from git that autogen.sh needs
      system "./autogen.sh"
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-guile
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make", "install"

    if OS.mac?
      (libexec/"gnubin").install_symlink bin/"gmake" =>"make"
      (libexec/"gnuman/man1").install_symlink man1/"gmake.1" => "make.1"
    end

    (libexec/"gnubin").install_symlink "../gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        GNU "make" has been installed as "gmake".
        If you need to use it as "make", you can add a "gnubin" directory
        to your PATH from your bashrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    (testpath/"Makefile").write <<~MAKE
      default:
      \t@echo guile $(if $(findstring guile,$(.FEATURES)),found,not found)
    MAKE

    if OS.mac?
      assert_equal "guile found\n", shell_output(bin/"gmake")
      assert_equal "guile found\n", shell_output(libexec/"gnubin/make")
    else
      assert_equal "guile found\n", shell_output(bin/"make")
    end
  end
end
