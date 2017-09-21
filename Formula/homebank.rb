class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.1.6.tar.gz"
  sha256 "2861e11590a00f5cbc505293821cb8caeabb74c26babe8a6a9d728f3404290e0"

  bottle do
    rebuild 1
    sha256 "525a76bfbc463b3e82ec304a0052836cd726778b5445e4e95de82149b9c2ba50" => :sierra
    sha256 "7c81a61b0d1e787070ebacbc1d047b3779674d628661ba1d4a3bfb417e1a161c" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "adwaita-icon-theme"
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
