class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://pkg-isocodes.alioth.debian.org/"
  url "https://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.74.tar.xz"
  sha256 "21f4f3cea8fe09f5b53784522303a0e1e7d083964ecaf1c75b1441d4d9ec6aee"
  head "https://anonscm.debian.org/git/pkg-isocodes/iso-codes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4db140774927b21d78ad33c7d72d63a208448af1f4782fd2f9be872ca9b6a03" => :sierra
    sha256 "81ec7286fb1b9390a3ce1d718003b6aae56addde3bf3e52a8f82e37ad178f5c2" => :el_capitan
    sha256 "81ec7286fb1b9390a3ce1d718003b6aae56addde3bf3e52a8f82e37ad178f5c2" => :yosemite
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
