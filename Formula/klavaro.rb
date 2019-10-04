class Klavaro < Formula
  desc "Free touch typing tutor program"
  homepage "https://klavaro.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/klavaro/klavaro-3.09.tar.bz2"
  sha256 "9983e501563a4d05e429700a2bd5bb078ac43b2f0d4014864e3cac42e0a1f589"
  revision 1

  bottle do
    sha256 "2a9619dd4f1c5bfe4bfb3506acd5f1ccd88a9db52961e633e37bba1bc53e4cec" => :mojave
    sha256 "d6cee4035c5d75253bab252217f795e1d2af5a8fcc248982fe909505c88792ea" => :high_sierra
    sha256 "5e99e56d3b855b9c6c6104622e32762008be3394a3008afbfe734b1d69aef522" => :sierra
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
