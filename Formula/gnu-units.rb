class GnuUnits < Formula
  desc "GNU unit conversion tool"
  homepage "https://www.gnu.org/software/units/"
  url "https://ftp.gnu.org/gnu/units/units-2.17.tar.gz"
  mirror "https://ftpmirror.gnu.org/units/units-2.17.tar.gz"
  sha256 "1f03c9f9aef1fb0ccddc6fb545f2925f7754de2bfa67d4e62f8758d7edfd5dd8"

  bottle do
    rebuild 1
    sha256 "2241945394f3434a78b46121da5039146a6c46308f9caf4fd962f23639d309b0" => :mojave
    sha256 "587ee2567c3c1b987d477460fb93b34e5f41ee89c5ce8f6e9dbf2aa141826fc5" => :high_sierra
    sha256 "9a2143c85ac0dc3b51654ece73c907b5a8a395fe221eaeef054708ae9459579a" => :sierra
    sha256 "5763af73624526f5859c4b1058cba6020ab49f582027197d2610bec9df52028e" => :el_capitan
  end

  option "with-default-names", "Do not prepend 'g' to the binary"

  deprecated_option "default-names" => "with-default-names"

  depends_on "readline"

  def install
    args = ["--prefix=#{prefix}", "--with-installed-readline"]
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"

    if build.without? "default-names"
      (libexec/"gnubin").install_symlink bin/"gunits" => "units"
      (libexec/"gnubin").install_symlink bin/"gunits_cur" => "units_cur"
      (libexec/"gnuman/man1").install_symlink man1/"gunits.1" => "units.1"
    end
  end

  test do
    assert_equal "* 18288", shell_output("#{bin}/gunits '600 feet' 'cm' -1").strip
  end
end
