class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.1.6.tar.gz"
  sha256 "2861e11590a00f5cbc505293821cb8caeabb74c26babe8a6a9d728f3404290e0"

  bottle do
    sha256 "d31666b5b8a1bcfd960fefe3b5703a07ac343705d2b21a86ace3a1c7bb7b574e" => :sierra
    sha256 "9d4844e119ff8697ee8be60708930a4e52465f8bac4201c3741c15db34b9dd47" => :el_capitan
    sha256 "c93d921f4d547201239ee9b81fcf082b7d101d23b35072c95c42f653fae71739" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "gnome-icon-theme"
  depends_on "hicolor-icon-theme"
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "libsoup"
  depends_on "libofx" => :optional

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--with-ofx" if build.with? "libofx"

    system "./configure", *args
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    system "#{bin}/homebank", "--version"
  end
end
