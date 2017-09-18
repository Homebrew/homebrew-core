class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://pkg-isocodes.alioth.debian.org/"
  url "https://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.76.tar.xz"
  sha256 "38ea8c1de7c07d5b4c9603ec65c238c155992a2e2ab0b02725d0926d1ad480c4"
  head "https://anonscm.debian.org/git/pkg-isocodes/iso-codes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "77ce7bfa85e5fa81139a7e60d01526d3d7c7894e0719dc2cfe78dc900c3194ae" => :high_sierra
    sha256 "b31364d6266ca38bf7b65748a745d823aa68a340041d922506d97867e4e17c14" => :sierra
    sha256 "75eaf27f6f5c568a1141252ef2617dead7fe99303b9e9850ba8b4efc412baee9" => :el_capitan
    sha256 "75eaf27f6f5c568a1141252ef2617dead7fe99303b9e9850ba8b4efc412baee9" => :yosemite
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
