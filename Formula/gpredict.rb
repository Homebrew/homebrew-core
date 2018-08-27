class Gpredict < Formula
  desc "Real-time satellite tracking/prediction application"
  homepage "http://gpredict.oz9aec.net/"
  url "https://github.com/csete/gpredict/releases/download/v2.2.1/gpredict-2.2.1.tar.bz2"
  sha256 "e759c4bae0b17b202a7c0f8281ff016f819b502780d3e77b46fe8767e7498e43"
  revision 1

  bottle do
    sha256 "400c62dd8752cdb30a94167fcd70d935fe45e724d0639a734ab2b4bf2ebd46f4" => :mojave
    sha256 "06a86999dd0aef8b9b48a6d2331f61cd402820cf9538933c9b0e1b3582a6a919" => :high_sierra
    sha256 "4dcd55867a496978ba69a96690e331610c944ed7f22a4561e7cca141ba4aad15" => :sierra
    sha256 "24336d811bd9568792d69f4a13d71e4184fd5ccd9282615e2a8a1277616dae32" => :el_capitan
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
