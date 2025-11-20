class GnuUnits < Formula
  desc "GNU unit conversion tool"
  homepage "https://www.gnu.org/software/units/"
  url "https://ftpmirror.gnu.org/gnu/units/units-2.24.tar.gz"
  mirror "https://ftp.gnu.org/gnu/units/units-2.24.tar.gz"
  sha256 "1e502c4edfacf20b29284716c72e5ddb51a495a2365d7b03e7960494c4a0c902"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "c55812a03fc96b5e043390bddf43d20282abed8ae16b3e33134f3525e5336818"
    sha256 arm64_sequoia: "3e72fb9e4acdec731e168551f9bbfa788ebe467cc0d3f28129a1431560c3aa9d"
    sha256 arm64_sonoma:  "6ac2aacbfcfb4ea86d625442d2fc37dbfe22ab1746f52176b69c1103ce1e5bf4"
    sha256 arm64_ventura: "1d94bdf2d4593f992e8ed62654ded6c99152af1200163e1268b4b815f91bc461"
    sha256 sonoma:        "bf0978be52268beff456873207f32b0f813214297bb54d1f2630b64b35456fe9"
    sha256 ventura:       "5356e61f7cf6dce7314c20185d1fa01e7a02ec77212ec344ddb2bca1058302a3"
    sha256 arm64_linux:   "7601d6c04c890e81d49201be1f9ded4eb56f97999be560dd364cfe49422bfc5d"
    sha256 x86_64_linux:  "c19b8b57e51bd23f71f929ad375b6d0defdc4347ff4993ddf5c26ed2088a0b39"
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
