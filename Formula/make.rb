class Make < Formula
  desc "Utility for directing compilation"
  homepage "https://www.gnu.org/software/make/"
  url "https://ftp.gnu.org/gnu/make/make-4.3.tar.lz"
  mirror "https://ftpmirror.gnu.org/make/make-4.3.tar.lz"
  sha256 "de1a441c4edf952521db30bfca80baae86a0ff1acd0a00402999344f04c45e82"

  bottle do
    sha256 "b2cbb6b854495469de4d065825c94540ad3053a1ff7c1832f4eb7781ee6b8231" => :catalina
    sha256 "50ac9c7185e08349c35531d8ee30e755713aec340229cab2008ba1a2ceac15c9" => :mojave
    sha256 "e7f49884dbeaae3e7ccc9dc3a58fec587c2a594f50314dbc33cde44c6f807f53" => :high_sierra
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --program-prefix=g
    ]

    system "./configure", *args
    system "make", "install"

    (libexec/"gnubin").install_symlink bin/"gmake" =>"make"
    (libexec/"gnuman/man1").install_symlink man1/"gmake.1" => "make.1"

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    <<~EOS
      GNU "make" has been installed as "gmake".
      If you need to use it as "make", you can add a "gnubin" directory
      to your PATH from your bashrc like:

          PATH="#{opt_libexec}/gnubin:$PATH"
    EOS
  end

  test do
    (testpath/"Makefile").write <<~EOS
      default:
      \t@echo Homebrew
    EOS

    assert_equal "Homebrew\n", shell_output("#{bin}/gmake")
    assert_equal "Homebrew\n", shell_output("#{opt_libexec}/gnubin/make")
  end
end
