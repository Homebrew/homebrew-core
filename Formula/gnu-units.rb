class GnuUnits < Formula
  desc "GNU unit conversion tool"
  homepage "https://www.gnu.org/software/units/"
  url "http://ftpmirror.gnu.org/units/units-2.12.tar.gz"
  mirror "https://ftp.gnu.org/gnu/units/units-2.12.tar.gz"
  sha256 "7868ea5118f1fe8e9f9f7256ecc7f1ee0dd7027ba9f32cc739184af1ed94bbcb"

  bottle do
    revision 2
    sha256 "bd921a8062e1975b950e1cd5997972b8e71c04d5b46327bee6d13e09d3eb3c48" => :el_capitan
    sha256 "862fc7428003aa51b056f37399084931306b48db105f3127375e0e75b9c0ff3e" => :yosemite
    sha256 "42fd2183ed7112794b546ac6115fcb2a7204af363d8a8685d40fad704a54dc5a" => :mavericks
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
