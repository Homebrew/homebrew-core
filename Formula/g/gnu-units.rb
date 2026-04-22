class GnuUnits < Formula
  desc "GNU unit conversion tool"
  homepage "https://www.gnu.org/software/units/"
  url "https://ftpmirror.gnu.org/gnu/units/units-2.27.tar.gz"
  mirror "https://ftp.gnu.org/gnu/units/units-2.27.tar.gz"
  sha256 "e1bbdb09672e7c08eee986749e7a1629eb84a6bdf41f5a2a79d6804444abbe10"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "1bfa5b9ccb5932b8517abef2af4e421ad782237868cadf9046ec3368f3a8d61d"
    sha256 arm64_sequoia: "0f83de7bbcba4d246ff388c2d6ced55bb0a1d129b62e9b550c30c8e92ae10888"
    sha256 arm64_sonoma:  "0eecf6ffaf5f6b5d7383ac6af26e5d8fb120ff2e21dc15a132401faba5bd069a"
    sha256 sonoma:        "0d619ebea3a4d427f217f12e073ea693760eb2ed75a0570a00eba5ca4b3cd372"
    sha256 arm64_linux:   "55e570d4e93da9b3f1703254056a786d56f25f16725e3d8b06a339870e7ac8b8"
    sha256 x86_64_linux:  "6bef3ad4bb7c1746ba681f0dfaa94c9290072dc1974466c3b8f5ad5e0ee13660"
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
    (libexec/"gnubin").install_symlink "../gnuman" => "man"
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
