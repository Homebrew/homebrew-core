class Make < Formula
  desc "Utility for directing compilation"
  homepage "https://www.gnu.org/software/make/"
  url "https://ftp.gnu.org/gnu/make/make-4.4.tar.lz"
  mirror "https://ftpmirror.gnu.org/make/make-4.4.tar.lz"
  sha256 "48d0fc0b2a04bb50f2911c16da65723285f7f4804c74fc5a2124a3df6c5f78c4"
  license "GPL-3.0-only"

  bottle do
    sha256 arm64_ventura:  "1eed07bf3c2d4521eb70271a5ef7be75a8d3401f9d1301a7a2925f217375bd5b"
    sha256 arm64_monterey: "5d70e49b345e20553a0bb4c85b73ba5da42940de229abf94957784df18f8f71d"
    sha256 arm64_big_sur:  "f1e067786d1da8f5eb10ef81fc7cd87de0b44417e8b100efd27682036124fb7c"
    sha256 ventura:        "186e88d292e2439443ad09929244d268a0ca2e2867045f2d0ca63f104e2efd68"
    sha256 monterey:       "ad56ca0950b6601ae210bc0279c0b35df6e6c3d432da5d93e69e5fe48b7b7690"
    sha256 big_sur:        "18c9d5fc5ca26000b4e1b470385fe7cbc263ff9193740c5b6055df2504654784"
    sha256 catalina:       "cd0512e7039014baa26887304f8f6adb01ab0335c7d5e6cf6406f515e4c2926b"
    sha256 x86_64_linux:   "f2357f38942958a9d49e2d8f7562bd9fc61c2c1e8471239c022240b71b8cbf7d"
  end

  conflicts_with "remake", because: "both install texinfo files for make"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make", "install"

    if OS.mac?
      (libexec/"gnubin").install_symlink bin/"gmake" =>"make"
      (libexec/"gnuman/man1").install_symlink man1/"gmake.1" => "make.1"
    end

    libexec.install_symlink "gnuman" => "man"
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
    (testpath/"Makefile").write <<~EOS
      default:
      \t@echo Homebrew
    EOS

    if OS.mac?
      assert_equal "Homebrew\n", shell_output("#{bin}/gmake")
      assert_equal "Homebrew\n", shell_output("#{opt_libexec}/gnubin/make")
    else
      assert_equal "Homebrew\n", shell_output("#{bin}/make")
    end
  end
end
