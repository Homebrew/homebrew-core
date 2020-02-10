class Gpredict < Formula
  desc "Real-time satellite tracking/prediction application"
  homepage "http://gpredict.oz9aec.net/"
  url "https://github.com/csete/gpredict/releases/download/v2.2.1/gpredict-2.2.1.tar.bz2"
  sha256 "e759c4bae0b17b202a7c0f8281ff016f819b502780d3e77b46fe8767e7498e43"
  revision 2

  bottle do
    sha256 "99fff9473dcc5eaa0c58cf0b2bf04f4240e1598aada45565e4dbbf050d2ac7dc" => :catalina
    sha256 "952941a2ecdb5f75805888dfd020acce48c4f1b29a9c2e3ec8742d35fcd9c829" => :mojave
    sha256 "189249444c490bc7984506a3d041de1d057fff671ff774871f549f6b32efa042" => :high_sierra
    sha256 "9a0a4b0e63b3b1f84830f508d60ee3fc5b5fd0b9a5731241873168baa88209cf" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gettext"
  depends_on "glib"
  depends_on "goocanvas"
  depends_on "gtk+3"
  depends_on "hamlib"

  uses_from_macos "curl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "real-time", shell_output("#{bin}/gpredict -h")
  end
end
