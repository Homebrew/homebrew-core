class GnuUnits < Formula
  desc "GNU unit conversion tool"
  homepage "https://www.gnu.org/software/units/"
  url "https://ftp.gnu.org/gnu/units/units-2.21.tar.gz"
  mirror "https://ftpmirror.gnu.org/units/units-2.21.tar.gz"
  sha256 "6c3e80a9f980589fd962a5852a2674642257db1c5fd5b27c4d9e664f3486cbaf"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "ff23e0b56f0d894c43fbdf4752045b2ff355953e23f7074218fec7d03b3bf98b"
    sha256 arm64_big_sur:  "843af59e54203a4235dd3522d10fa7d5b6aad5e7326b3ef858c35df7e3e35b84"
    sha256 monterey:       "4f06e478e37881dd36a7526d054b02694d1d487ad91248832c25a8cd727c1aa8"
    sha256 big_sur:        "67c4941efc8a2b0b2b76193f28a83381cea01b74a2e981fb51222cc87e497aca"
    sha256 catalina:       "9a3735d1c7a52c9c4a1e2f81e1b0219a2621c3d32be663a085c5a1c48299a6d5"
    sha256 mojave:         "720dc5aea47a82932ca0cb33b4a45ec3b4ac5c7910274c0dc925a371493f3b32"
    sha256 x86_64_linux:   "d5a3a5af1eeb39c44a19c10af79f557cc926a686753674c42424365eb4f6cc1c"
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
