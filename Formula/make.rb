class Make < Formula
  desc "Utility for directing compilation"
  homepage "https://www.gnu.org/software/make/"
  url "https://ftp.gnu.org/gnu/make/make-4.2.1.tar.bz2"
  mirror "https://ftpmirror.gnu.org/make/make-4.2.1.tar.bz2"
  sha256 "d6e262bf3601b42d2b1e4ef8310029e1dcf20083c5446b4b7aa67081fdffc589"
  revision 1

  bottle do
    sha256 "f66663049c05cc00e90cb7798db57efbcff3c2945abdbc9464a7da295d64b04e" => :mojave
    sha256 "8b4c8c8b98b7480237a841539372c30c96f3bbfdcacc0e933e4fa83910fd7e46" => :high_sierra
    sha256 "c369d10d81412b5402be1e14be57a4074278b59dfe0a1c9e348e0cd46a533878" => :sierra
    sha256 "969c45027b8e0aa4a4a2fea0ad6e2d3ff311b55080d017b93239f2611e131ef2" => :el_capitan
    sha256 "c094c8b7e6cb3438d16378a4748f4c8930be5c82fc99408fb40ee27556d9a84a" => :yosemite
  end

  option "with-default-names", "Do not prepend 'g' to the binary"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"

    if build.without? "default-names"
      (libexec/"gnubin").install_symlink bin/"gmake" =>"make"
      (libexec/"gnuman/man1").install_symlink man1/"gmake.1" => "make.1"
    end
  end

  def caveats
    if build.without? "default-names"
      <<~EOS
        All commands have been installed with the prefix 'g'.
        If you do not want the prefix, install using the "with-default-names" option.

        If you need to use these commands with their normal names, you
        can add a "gnubin" directory to your PATH from your bashrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"

        Additionally, you can access their man pages with normal names if you add
        the "gnuman" directory to your MANPATH from your bashrc as well:

            MANPATH="#{opt_libexec}/gnuman:$MANPATH"
      EOS
    end
  end

  test do
    (testpath/"Makefile").write <<~EOS
      default:
      \t@echo Homebrew
    EOS

    cmd = build.with?("default-names") ? "make" : "gmake"

    assert_equal "Homebrew\n",
      shell_output("#{bin}/#{cmd}")
  end
end
