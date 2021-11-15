class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://salsa.debian.org/iso-codes-team/iso-codes"
  url "https://deb.debian.org/debian/pool/main/i/iso-codes/iso-codes_4.8.0.orig.tar.xz"
  sha256 "b02b9c8bb81dcfa03e4baa25b266df47710832cbf550081cf43f72dcedfc8768"
  license "LGPL-2.1-or-later"
  head "https://salsa.debian.org/iso-codes-team/iso-codes.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c27f3b850cca2166c7cb79fad9ad835f622e2f742a2e2ce4dd773b9fb8733a1b"
  end

  depends_on "gettext" => :build
  depends_on "python@3.9" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("grep domains #{share}/pkgconfig/iso-codes.pc")
    assert_match "iso_639-2 iso_639-3 iso_639-5 iso_3166-1", output
  end
end
