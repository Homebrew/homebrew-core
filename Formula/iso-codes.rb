class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://pkg-isocodes.alioth.debian.org/"
  url "https://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.75.tar.xz"
  sha256 "7335e0301cd77cd4ee019bf5d3709aa79309d49dd66e85ba350caf67e00b00cd"
  head "https://anonscm.debian.org/git/pkg-isocodes/iso-codes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f51560d019e402c0571b1218b9380449e7b3c0049529e6b4d9d99f0c5fe3537b" => :sierra
    sha256 "f01c5cd9f3254fe006a225a17cafe51ab926b21ce8a2e9d56932c32d2ce028b6" => :el_capitan
    sha256 "f01c5cd9f3254fe006a225a17cafe51ab926b21ce8a2e9d56932c32d2ce028b6" => :yosemite
  end

  depends_on "gettext" => :build
  depends_on :python3
  depends_on "pkg-config" => :run

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
