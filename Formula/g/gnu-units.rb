class GnuUnits < Formula
  desc "GNU unit conversion tool"
  homepage "https://www.gnu.org/software/units/"
  url "https://ftpmirror.gnu.org/gnu/units/units-2.26.tar.gz"
  mirror "https://ftp.gnu.org/gnu/units/units-2.26.tar.gz"
  sha256 "4c43f7a49fe2212ee433d3c0755a0a1935db35497c4a56bf9f68c5f718873c54"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "9a69e56dc2085d57456a0985f04fc72e0b84b246763e08a2cefe1b6428ca302b"
    sha256 arm64_sequoia: "4f2543f0bffdfd9c05da174c4201f47fa601ccbae0ec0b7ed5afdb41c210a383"
    sha256 arm64_sonoma:  "02f3f43146c3c32888bd8ec91ddd310f72ee7ad6a6483f39112a37a6012dccc4"
    sha256 sonoma:        "09c0231fe742c2cb3d4fdcb0d1bfa224e64e247f0b78ed93b35ca661a33dd99a"
    sha256 arm64_linux:   "c15e11c53430a74765f0650e47742d10acc4f162c22e6d2f7881eb228aba8088"
    sha256 x86_64_linux:  "dec4d4db96599675669c5ab715175a9808d1808c921e37d9bd46ed5b71911af3"
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
