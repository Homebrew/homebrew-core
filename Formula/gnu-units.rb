class GnuUnits < Formula
  desc "GNU unit conversion tool"
  homepage "https://www.gnu.org/software/units/"
  url "https://ftp.gnu.org/gnu/units/units-2.17.tar.gz"
  mirror "https://ftpmirror.gnu.org/units/units-2.17.tar.gz"
  sha256 "1f03c9f9aef1fb0ccddc6fb545f2925f7754de2bfa67d4e62f8758d7edfd5dd8"

  bottle do
    sha256 "7c1b738b9a2211a5878a5e93b8fc1e0872b96ef2621089935c63affefb111210" => :high_sierra
    sha256 "b7dd84962f44459c34754c315ff0840721a8612b42663366f63a69f2ba1b6f3d" => :sierra
    sha256 "d735946b103d42cbc06f771b157312db9e513e0a351f285aa7cd681ade7ab437" => :el_capitan
  end

  deprecated_option "default-names" => "with-default-names"

  option "with-default-names", "Do not prepend 'g' to the binary"

  depends_on "readline"

  def install
    args = ["--prefix=#{prefix}", "--with-installed-readline"]
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_equal "* 18288", shell_output("#{bin}/gunits '600 feet' 'cm' -1").strip
  end
end
