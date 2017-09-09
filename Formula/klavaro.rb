class Klavaro < Formula
  desc "Free touch typing tutor program"
  homepage "https://klavaro.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/klavaro/klavaro-3.03.tar.bz2"
  sha256 "e0959f21e54e7f4700042a3a14987a7f8fc898701eab4f721ebcf4559a2c87b5"

  bottle do
    sha256 "4024187379c8dced802206da91fe6d771e618f6eeaaecf327dfd114908ece438" => :sierra
    sha256 "1fc81369acf6063bbd0905976443a3dff4bc053c4ae975675b9ff6ddfb00f10c" => :el_capitan
    sha256 "ecbf95acf3edaa13be06446c8e00a3236b4cd48417e6feeabe0f67363b721d89" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gtk+3"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"klavaro", "--help-gtk"
  end
end
