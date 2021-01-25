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
    sha256 "67c4941efc8a2b0b2b76193f28a83381cea01b74a2e981fb51222cc87e497aca" => :big_sur
    sha256 "843af59e54203a4235dd3522d10fa7d5b6aad5e7326b3ef858c35df7e3e35b84" => :arm64_big_sur
    sha256 "9a3735d1c7a52c9c4a1e2f81e1b0219a2621c3d32be663a085c5a1c48299a6d5" => :catalina
    sha256 "720dc5aea47a82932ca0cb33b4a45ec3b4ac5c7910274c0dc925a371493f3b32" => :mojave
  end

  depends_on "readline"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-installed-readline
    ]

    on_macos do
      args << "--program-prefix=g"
    end
    system "./configure", *args
    system "make", "install"

    on_macos do
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
    on_macos do
      assert_equal "* 18288", shell_output("#{bin}/gunits '600 feet' 'cm' -1").strip
      assert_equal "* 18288", shell_output("#{opt_libexec}/gnubin/units '600 feet' 'cm' -1").strip
    end
    on_linux do
      assert_equal "* 18288", shell_output("#{bin}/units '600 feet' 'cm' -1").strip
    end
  end
end
