class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://pkg-isocodes.alioth.debian.org/"
  url "https://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.69.tar.xz"
  sha256 "3f285d3c13f4dccfbdb9e432f172403ac1a54ab432616f10556eb18c23a1c0b2"
  head "https://anonscm.debian.org/git/pkg-isocodes/iso-codes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef21da74993d57980282de773b910ba1c5cc132169489c20eff7031561f1c269" => :el_capitan
    sha256 "6079021c10658f3f3d03782c860209dea068f7ee9258bd42db35e42914ba0ce5" => :yosemite
    sha256 "53cac9a91c95fdc9a066c0af51e0405f486fb1f3bc07d9cb1b8cbe5249c2ab13" => :mavericks
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
