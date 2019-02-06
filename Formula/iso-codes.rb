class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://salsa.debian.org/iso-codes-team/iso-codes"
  url "https://deb.debian.org/debian/pool/main/i/iso-codes/iso-codes_4.2.orig.tar.xz"
  sha256 "2b7f66c81808ac52e1ed0efe4ce8ae8e43309eedcc411f94f71a3f603cc21f42"
  head "https://salsa.debian.org/iso-codes-team/iso-codes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5794f777543492894617f8f4b8ab0d38049a5c2685bd858e62a485cdf681cc29" => :mojave
    sha256 "17b7b4a43e707d1fce551eef2b31a22ec1a94d8580bce165bdeeaa3f08ce4ccd" => :high_sierra
    sha256 "17b7b4a43e707d1fce551eef2b31a22ec1a94d8580bce165bdeeaa3f08ce4ccd" => :sierra
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
