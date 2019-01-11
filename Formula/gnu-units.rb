class GnuUnits < Formula
  desc "GNU unit conversion tool"
  homepage "https://www.gnu.org/software/units/"
  url "https://ftp.gnu.org/gnu/units/units-2.18.tar.gz"
  mirror "https://ftpmirror.gnu.org/units/units-2.18.tar.gz"
  sha256 "64959c231c280ceb4f3e6ae6a19b918247b6174833f7f1894704c444869c4678"

  bottle do
    rebuild 2
    sha256 "2570ac9d62c68482b03f6697c773f829347049763ad36ff68c9d0cfcad9eaba8" => :mojave
    sha256 "54f54a751537e3810a5d89874d6929f08f1e78c66962c1a7ebe107ecf4a814a0" => :high_sierra
    sha256 "a02b9fd8e8c8701b8026808eb6fd4cfbc3e4b6be7c3476948ac1e7b784166c8b" => :sierra
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

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats; <<~EOS
    All commands have been installed with the prefix "g".
    If you need to use these commands with their normal names, you
    can add a "gnubin" directory to your PATH from your bashrc like:
      PATH="#{opt_libexec}/gnubin:$PATH"
  EOS
  end

  test do
    assert_equal "* 18288", shell_output("#{bin}/gunits '600 feet' 'cm' -1").strip
    assert_equal "* 18288", shell_output("#{opt_libexec}/gnubin/units '600 feet' 'cm' -1").strip
  end
end
