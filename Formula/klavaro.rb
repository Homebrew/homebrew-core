class Klavaro < Formula
  desc "Free touch typing tutor program"
  homepage "https://klavaro.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/klavaro/klavaro-3.11.tar.bz2"
  sha256 "fc64d3bf9548a5d55af1ba72912024107883a918b95ae60cda95706116567de6"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/klavaro[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "cdcfb850a7948e249c28f38c29fd425bf4b60c36751d881a197bd027849f4cf6" => :catalina
    sha256 "ddd221d6a3d97da22c6a257076df29e1c8795dd2a47b4c9eb76782d451a26a35" => :mojave
    sha256 "3f75e1159ad6a743c00d9b00583bb8b99eaa66875f3316b437b6e3e63f99aa8a" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    rm_rf include
  end

  test do
    system bin/"klavaro", "--help-gtk"
  end
end
