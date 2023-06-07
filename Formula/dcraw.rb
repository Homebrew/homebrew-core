class Dcraw < Formula
  desc "Digital camera RAW photo decoding software"
  homepage "https://www.dechifro.org/dcraw/"
  url "https://www.dechifro.org/dcraw/archive/dcraw-9.28.0.tar.gz"
  mirror "https://mirrorservice.org/sites/distfiles.macports.org/dcraw/dcraw-9.28.0.tar.gz"
  sha256 "2890c3da2642cd44c5f3bfed2c9b2c1db83da5cec09cc17e0fa72e17541fb4b9"
  revision 3

  livecheck do
    url "https://distfiles.macports.org/dcraw/"
    regex(/href=.*?dcraw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5c293d628459ac1405a5d558d975f2e655e6a59626a4a634fd6496b094a7589c"
    sha256 cellar: :any,                 arm64_monterey: "3335474ee80fb8359df924187d878380b76ee055ca0ade45f1b8872cf71b1614"
    sha256 cellar: :any,                 arm64_big_sur:  "fcf8d42c26fe0f0c75b9247286ab8dc90cca127b4946dc5755cfd44d5afd66a5"
    sha256 cellar: :any,                 ventura:        "2ece1b23d5c77ada535e6e4ae803b9d8060296838cfe92818c191b1e49dceba8"
    sha256 cellar: :any,                 monterey:       "82b85b19458214ddae5f12e22a13e160b5a771d1111020d559a3b19bfed3798f"
    sha256 cellar: :any,                 big_sur:        "baf800fb4217afc09f8fc06f3512780898018e72e8862be65f016ea1b89fb91d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e450712cc23c8501e21e7ff438480b0debcb27703a6ba4dcea9e6b00a2ec6fac"
  end

  depends_on "jasper"
  depends_on "jpeg-turbo"
  depends_on "little-cms2"

  def install
    ENV.append "LDLIBS", "-lm -ljpeg -llcms2 -ljasper"
    system "make", "dcraw"
    bin.install "dcraw"
    man1.install "dcraw.1"
  end

  test do
    assert_match "\"dcraw\" v9", shell_output("#{bin}/dcraw", 1)
  end
end
