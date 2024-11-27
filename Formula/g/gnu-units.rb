class GnuUnits < Formula
  desc "GNU unit conversion tool"
  homepage "https://www.gnu.org/software/units/"
  url "https://ftp.gnu.org/gnu/units/units-2.23.tar.gz"
  mirror "https://ftpmirror.gnu.org/units/units-2.23.tar.gz"
  sha256 "d957b451245925c9e614c4513397449630eaf92bd62b8495ba09bbe351a17370"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "c9ef167a1cbb1045a908eebe83e1d88c94b569aa6cb59a5a2f70e3270e7da784"
    sha256 arm64_sonoma:   "473f619fae31245e4b4d04c66e74b0363cb64d43964a5e82307d2dae10e20254"
    sha256 arm64_ventura:  "e364dbbb0ad04977a9e1ac93c47355a153e4b3b73089b126ea708df02dd24029"
    sha256 arm64_monterey: "b0153e8b43b52bcdec45fd79d59208658fad30548138ccb8be565975daee2373"
    sha256 sonoma:         "22d8e72eb6255cdb7530e64d86d2e93eff2a6346ff0000c48d64b9c998f251a2"
    sha256 ventura:        "100129725430b6f71f48ee93d999c0735cea0e6bfac0d2f4d0c4505329a6ac29"
    sha256 monterey:       "8d116d2d4e98f362e0213daf131db29d60282df0e83838feaa9eb0c4aa9d9d36"
    sha256 x86_64_linux:   "cca502b31e282cfffb7c30ffc204cecdf2d6a9aba8b23310e886719096465fe0"
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
