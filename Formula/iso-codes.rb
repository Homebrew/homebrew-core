class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://pkg-isocodes.alioth.debian.org/"
  url "https://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.71.tar.xz"
  sha256 "013df6ac35fb0b9e3244c6a4f13a1090d61cb4478f7cd468bbf46be983ba1f74"
  head "https://anonscm.debian.org/git/pkg-isocodes/iso-codes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c38391ca36a8b3a36548110e9949675246b2ab09f538e07ee5e2b08285ccbc3" => :sierra
    sha256 "6c38391ca36a8b3a36548110e9949675246b2ab09f538e07ee5e2b08285ccbc3" => :el_capitan
    sha256 "6c38391ca36a8b3a36548110e9949675246b2ab09f538e07ee5e2b08285ccbc3" => :yosemite
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
