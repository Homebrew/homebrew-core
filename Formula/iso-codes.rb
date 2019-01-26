class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://salsa.debian.org/iso-codes-team/iso-codes"
  url "https://deb.debian.org/debian/pool/main/i/iso-codes/iso-codes_4.2.orig.tar.xz"
  sha256 "2b7f66c81808ac52e1ed0efe4ce8ae8e43309eedcc411f94f71a3f603cc21f42"
  head "https://salsa.debian.org/iso-codes-team/iso-codes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dbff19319e650b2b21b786b6e1910cde017061d4d3b8f94b00536c4ed5b952aa" => :mojave
    sha256 "efd955789c4db00603c3f408efe76a1b022481e8a3195a64374367e361f78daa" => :high_sierra
    sha256 "efd955789c4db00603c3f408efe76a1b022481e8a3195a64374367e361f78daa" => :sierra
    sha256 "efd955789c4db00603c3f408efe76a1b022481e8a3195a64374367e361f78daa" => :el_capitan
  end

  depends_on "gettext" => :build
  depends_on "pkg-config"
  depends_on "python"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    pkg_config = Formula["pkg-config"].opt_bin/"pkg-config"
    output = shell_output("#{pkg_config} --variable=domains iso-codes")
    assert_match "iso_639-2 iso_639-3 iso_639-5 iso_3166-1", output
  end
end
