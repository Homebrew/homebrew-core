class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://pkg-isocodes.alioth.debian.org/"
  url "https://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.77.tar.xz"
  sha256 "21cd73a4c6f95d9474ebfcffd4e065223857720f24858e564f4409b19f7f0d90"
  revision 2
  head "https://anonscm.debian.org/git/pkg-isocodes/iso-codes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cee71f875da473301679858f6a32032bf6f1b78a8b857565ac0ae4c50237b9c9" => :high_sierra
    sha256 "cee71f875da473301679858f6a32032bf6f1b78a8b857565ac0ae4c50237b9c9" => :sierra
    sha256 "cee71f875da473301679858f6a32032bf6f1b78a8b857565ac0ae4c50237b9c9" => :el_capitan
  end

  depends_on "gettext" => :build
  depends_on "python"
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
