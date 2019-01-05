class GnuUnits < Formula
  desc "GNU unit conversion tool"
  homepage "https://www.gnu.org/software/units/"
  url "https://ftp.gnu.org/gnu/units/units-2.18.tar.gz"
  mirror "https://ftpmirror.gnu.org/units/units-2.18.tar.gz"
  sha256 "64959c231c280ceb4f3e6ae6a19b918247b6174833f7f1894704c444869c4678"

  bottle do
    rebuild 1
    sha256 "0e53b24aacb7f43b04827b8aa8b2f2b7dc5a8e8e983cfe0aff96a4a7188be6bb" => :mojave
    sha256 "103a1b009704edce77f545c8d88d87247f9d3f17c819bc8dad2c0eb80e12dce5" => :high_sierra
    sha256 "8f3c81dedbd869e5cd946e6ad9545872acf8c8c51cb49389eb5f729eefde8ccf" => :sierra
  end

  depends_on "readline"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-installed-readline
      --program-prefix=g
    ]

    system "./configure", *args
    system "make", "install"

    (libexec/"gnubin").install_symlink bin/"gunits" => "units"
    (libexec/"gnubin").install_symlink bin/"gunits_cur" => "units_cur"
    (libexec/"gnuman/man1").install_symlink man1/"gunits.1" => "units.1"
  end

  def caveats; <<~EOS
    All commands have been installed with the prefix "g".
    If you need to use these commands with their normal names, you
    can add a "gnubin" directory to your PATH from your bashrc like:
      PATH="#{opt_libexec}/gnubin:$PATH"

    Additionally, you can access their man pages with normal names if you add
    the "gnuman" directory to your MANPATH from your bashrc as well:
      MANPATH="#{opt_libexec}/gnuman:$MANPATH"
  EOS
  end

  test do
    assert_equal "* 18288", shell_output("#{bin}/gunits '600 feet' 'cm' -1").strip
    assert_equal "* 18288", shell_output("#{opt_libexec}/gnubin/units '600 feet' 'cm' -1").strip
  end
end
