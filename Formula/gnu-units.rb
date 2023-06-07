class GnuUnits < Formula
  desc "GNU unit conversion tool"
  homepage "https://www.gnu.org/software/units/"
  url "https://ftp.gnu.org/gnu/units/units-2.22.tar.gz"
  mirror "https://ftpmirror.gnu.org/units/units-2.22.tar.gz"
  sha256 "5d13e1207721fe7726d906ba1d92dc0eddaa9fc26759ed22e3b8d1a793125848"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "513874dc0676da8124c51c057b940752ed76663c6d290c11b33fc7767a84b2cb"
    sha256 arm64_monterey: "642c474a2809e0d9db1d0db76e37f02913da673cfc4fdc337d3b4f4412dd9058"
    sha256 arm64_big_sur:  "c7a080c4aba8efa918476470972561d4a8e3ead5d808f02fcbf41c50226d5602"
    sha256 ventura:        "ef142fd61422ad8cb76d4baaeaa71847ebbbf6c54fd351bda9d407d258d4e933"
    sha256 monterey:       "07de02b9e3aa4e1dae47247a30a29c4e8b09013778d6efd040a0774136996a75"
    sha256 big_sur:        "ed207519d9523dffa34a8000d8d40f2488a439c29527a07dd0d00a29aa093b3c"
    sha256 catalina:       "fb2ec95d8a26caf1a11accecc6b93f825ebe07c098b249a876e257a066b7f836"
    sha256 x86_64_linux:   "86b47abf6076ba0dfbbc413eb6cb6031636d097e276fb8526d3cb62227bfd8ea"
  end

  depends_on "readline"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-installed-readline
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make", "install"

    if OS.mac?
      (libexec/"gnubin").install_symlink bin/"gunits" => "units"
      (libexec/"gnubin").install_symlink bin/"gunits_cur" => "units_cur"
      (libexec/"gnuman/man1").install_symlink man1/"gunits.1" => "units.1"
    end
    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        All commands have been installed with the prefix "g".
        If you need to use these commands with their normal names, you
        can add a "gnubin" directory to your PATH from your bashrc like:
          PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    if OS.mac?
      assert_equal "* 18288", shell_output("#{bin}/gunits '600 feet' 'cm' -1").strip
      assert_equal "* 18288", shell_output("#{opt_libexec}/gnubin/units '600 feet' 'cm' -1").strip
    else
      assert_equal "* 18288", shell_output("#{bin}/units '600 feet' 'cm' -1").strip
    end
  end
end
