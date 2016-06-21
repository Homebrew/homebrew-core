class GnuUnits < Formula
  desc "GNU unit conversion tool"
  homepage "https://www.gnu.org/software/units/"
  url "http://ftpmirror.gnu.org/units/units-2.13.tar.gz"
  mirror "https://ftp.gnu.org/gnu/units/units-2.13.tar.gz"
  sha256 "0ba5403111f8e5ea22be7d51ab74c8ccb576dc30ddfbf18a46cb51f9139790ab"

  bottle do
    sha256 "945af21fb90242bc27210c6006e9592a9f41a1e42525703adf9ee285b6230336" => :el_capitan
    sha256 "619546f41b4c1a0c5a766cbb389ee85c47f5cd5853abf297ec500144e6b1cc50" => :yosemite
    sha256 "7aadfeebfa644b3d2d2d86f642eb365983f8ffba859cb1782530a7ee0c2f307b" => :mavericks
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
