class GnuUnits < Formula
  desc "GNU unit conversion tool"
  homepage "https://www.gnu.org/software/units/"
  url "https://ftpmirror.gnu.org/units/units-2.13.tar.gz"
  mirror "https://ftp.gnu.org/gnu/units/units-2.13.tar.gz"
  sha256 "0ba5403111f8e5ea22be7d51ab74c8ccb576dc30ddfbf18a46cb51f9139790ab"
  revision 1

  bottle do
    sha256 "699fbab4137b66d9ace24f214ba3cd0aa63182a40118b372452fb82ba33f249b" => :sierra
    sha256 "892045f56500951d7c109c20a103cb05ed37859bffdcf0fea959c269731e49d5" => :el_capitan
    sha256 "0e634f131a2985299248f35a7bffc4b4854e4cd5c704e295c9fb7bed80d63279" => :yosemite
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
