class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://salsa.debian.org/iso-codes-team/iso-codes"
  url "https://deb.debian.org/debian/pool/main/i/iso-codes/iso-codes_4.2.orig.tar.xz"
  sha256 "2b7f66c81808ac52e1ed0efe4ce8ae8e43309eedcc411f94f71a3f603cc21f42"
  revision 1
  head "https://salsa.debian.org/iso-codes-team/iso-codes.git"

  depends_on "gettext" => :build
  depends_on "python" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    output = shell_output("grep domains #{share}/pkgconfig/iso-codes.pc")
    assert_match "iso_639-2 iso_639-3 iso_639-5 iso_3166-1", output
  end
end
