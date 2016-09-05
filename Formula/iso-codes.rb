class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://pkg-isocodes.alioth.debian.org/"
  url "https://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.70.tar.xz"
  sha256 "41e2fbaec2ed57e767b94f175d0dcd31b627aeb23b75cd604605a6fb6109d61f"
  head "https://anonscm.debian.org/git/pkg-isocodes/iso-codes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a96158544c05f0922ef214646106f4bb6d36e036dd9ce19a8b6b145fb0e2fb26" => :el_capitan
    sha256 "3a24458ee3c2e50301a6a12b055bed0a32b99b2f8ae3391d9a3b84499b5043d2" => :yosemite
    sha256 "3a24458ee3c2e50301a6a12b055bed0a32b99b2f8ae3391d9a3b84499b5043d2" => :mavericks
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
