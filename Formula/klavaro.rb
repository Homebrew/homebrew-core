class Klavaro < Formula
  desc "Free touch typing tutor program"
  homepage "https://klavaro.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/klavaro/klavaro-3.11.tar.bz2"
  sha256 "fc64d3bf9548a5d55af1ba72912024107883a918b95ae60cda95706116567de6"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/klavaro[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "41b9587830f9220f6a91c21e8891e0902c59c10dc88dee82461e244e001b703b"
    sha256 big_sur:       "55a3a6d28e83c6ee14f2a11c8d43023a4cabbf2513209d85e662f97ceb834d1c"
    sha256 catalina:      "0e8d999d277da066fe7e2e8bd4f13d8e82da94cdc6349b141bae1123317111ae"
    sha256 mojave:        "edc900c59a4ea4fe50e75a5ac0be451739931cae3d77ff8691229e6f3ead8eb3"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
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
