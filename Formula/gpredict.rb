class Gpredict < Formula
  desc "Real-time satellite tracking/prediction application"
  homepage "http://gpredict.oz9aec.net/"
  url "https://github.com/csete/gpredict/releases/download/v2.2.1/gpredict-2.2.1.tar.bz2"
  sha256 "e759c4bae0b17b202a7c0f8281ff016f819b502780d3e77b46fe8767e7498e43"

  bottle do
    sha256 "26b0216abfb1c2d1601d8b24667f557532f7462960a5f58ef73bf65ccc2a4981" => :high_sierra
    sha256 "309c22db1bc600a8b91f7b846ad8961d17f70a021563d01cbe2a7d9f2107f2cd" => :sierra
    sha256 "0b1a958f2251ee438ef97b6825ba4423d3cb1a7ccdd1b15389f3cd77e7e36f8f" => :el_capitan
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gettext"
  depends_on "glib"
  depends_on "goocanvas"
  depends_on "gtk+3"
  depends_on "hamlib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "real-time", shell_output("#{bin}/gpredict -h")
  end
end
