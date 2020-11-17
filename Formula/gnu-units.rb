class GnuUnits < Formula
  desc "GNU unit conversion tool"
  homepage "https://www.gnu.org/software/units/"
  url "https://ftp.gnu.org/gnu/units/units-2.21.tar.gz"
  mirror "https://ftpmirror.gnu.org/units/units-2.21.tar.gz"
  sha256 "6c3e80a9f980589fd962a5852a2674642257db1c5fd5b27c4d9e664f3486cbaf"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "31caa8a266a1565f9ded8df385aa85395ee442e310cd5e483dfa87fb05c692d4" => :big_sur
    sha256 "8349a1d519d546b0e900099d654225f8b722549687a61b34101caddff8ea1c19" => :catalina
    sha256 "b00474fcb014e19244ad5dee6152164c02dba0a15892cf3e7d8b7d4b3e8faecb" => :mojave
    sha256 "eda9851ba0da4b3facfeb56f6997d075915f8b55a468c0bfaa3571839e91c750" => :high_sierra
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

  def caveats
    <<~EOS
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
