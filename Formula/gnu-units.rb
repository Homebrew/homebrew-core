class GnuUnits < Formula
  desc "GNU unit conversion tool"
  homepage "https://www.gnu.org/software/units/"
  url "https://ftp.gnu.org/gnu/units/units-2.15.tar.gz"
  mirror "https://ftpmirror.gnu.org/units/units-2.15.tar.gz"
  sha256 "25d6334fafc801e15b3b0388e207e1efc5d4ae88af6dc7b17d3913de6441f47c"

  bottle do
    sha256 "6e3a72a2e7391796bc6871e3941e56b95b50bf399995146d827c3269ae166f5f" => :high_sierra
    sha256 "2f2e9cba813d42b5433e9dd8d3d3f7438536ad25ab1e03ff92ce92109c15ec1b" => :sierra
    sha256 "966e5ae5598ad8340de8840e0dab273f7ecc2193bf932a533078c78f4d702779" => :el_capitan
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
