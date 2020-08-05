class BwmNg < Formula
  desc "Console-based live network and disk I/O bandwidth monitor"
  homepage "https://www.gropp.org/?id=projects&sub=bwm-ng"
  url "https://github.com/vgropp/bwm-ng/archive/v0.6.2.tar.gz"
  sha256 "906a2d561f2ec9e0dd68b7f51b302908e99515ea1216d0ecaf14d873ef54ae70"
  head "https://github.com/vgropp/bwm-ng.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "99d28681821e0c8114f4d1ea8db15ff088beb61d755e657c4a43684292cf556d" => :catalina
    sha256 "4126db28facbbd0c0575d166a4c30968c4449b8094430022d3c8455ec7481809" => :mojave
    sha256 "4a8ffbfe0bc2c9bf93bd516cff8916e9ea1d9554d939f21c4f7e9bfbd02ab04f" => :high_sierra
    sha256 "0c663c3fedbcdc690b553ccb88b6f69b94a4a70dea67e3d152dbaaa741973ba8" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    ENV.append "CFLAGS", "-std=gnu89"

    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "<div class=\"bwm-ng-header\">", shell_output("#{bin}/bwm-ng -o html")
  end
end
