class GnuUnits < Formula
  desc "GNU unit conversion tool"
  homepage "https://www.gnu.org/software/units/"
  url "https://ftpmirror.gnu.org/units/units-2.13.tar.gz"
  mirror "https://ftp.gnu.org/gnu/units/units-2.13.tar.gz"
  sha256 "0ba5403111f8e5ea22be7d51ab74c8ccb576dc30ddfbf18a46cb51f9139790ab"
  revision 1

  bottle do
    sha256 "66934e9cc51bc341484bd1f8a6380292ddcd1a0a776b92517e726bbf06a860f1" => :sierra
    sha256 "76982a809c64af4f45e97cc450cd717b4a12fef538c78ba362bf45b0e49877cb" => :el_capitan
    sha256 "ad75ca96d61f7f09dd95c831b6b468e04c4912e9834bebea17a02162758e0f9b" => :yosemite
    sha256 "89fe5cd2960513e836909fae964b0e787d8b9747711cc1cee79fc30be2332fcd" => :mavericks
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
