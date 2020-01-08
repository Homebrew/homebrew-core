class Make < Formula
  desc "Utility for directing compilation"
  homepage "https://www.gnu.org/software/make/"
  url "https://ftp.gnu.org/gnu/make/make-4.2.1.tar.bz2"
  mirror "https://ftpmirror.gnu.org/make/make-4.2.1.tar.bz2"
  sha256 "d6e262bf3601b42d2b1e4ef8310029e1dcf20083c5446b4b7aa67081fdffc589"
  revision 1

  bottle do
    rebuild 3
    sha256 "250c966a63e8e661f6c5f38669f3ea6bebeaeccb7cc4f797116e63d5580bf1d8" => :catalina
    sha256 "c457485b491cccb4a03059e38244b14e7c7f54abb377fa31874848cc786b54ff" => :mojave
    sha256 "d1788bda69cb9fad4fa9225ee111503ff3b8dee37901878f380c3a27ee62b8f0" => :high_sierra
    sha256 "1d55b106718979c19a8e6ad9974fe9dbea6501daafcf0014e80143efd37dd74e" => :sierra
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

  def caveats; <<~EOS
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
