class GnuUnits < Formula
  desc "GNU unit conversion tool"
  homepage "https://www.gnu.org/software/units/"
  url "https://ftp.gnu.org/gnu/units/units-2.14.tar.gz"
  mirror "https://ftpmirror.gnu.org/units/units-2.14.tar.gz"
  sha256 "9d33893d82f3ddd831d5822992007c40bcd0826ae67d3cbc96539951fb0a82e8"

  bottle do
    sha256 "2af636ef04bbd4c2846561cb2c7112f616bc80a88caf25ddc72614029241fe46" => :sierra
    sha256 "38e5baed18c905ab510f459f8eba0e8e4f30ec8a0b107e9e6063ade8241cb1da" => :el_capitan
    sha256 "82dbdef4dd830d9c895e3c2f4065a837e979583ef01480ae217982a48e249829" => :yosemite
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
