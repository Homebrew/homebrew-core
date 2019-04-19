class Klavaro < Formula
  desc "Free touch typing tutor program"
  homepage "https://klavaro.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/klavaro/klavaro-3.05.tar.bz2"
  sha256 "fe82c6c108a3c40ab97902a8874c6d10fd891b4ff1accce757e5cba0e361dd10"

  bottle do
    sha256 "c590d7ac68930ecc99736f75a47fffba91beac782c61b6bbff88b8d34d863c3d" => :mojave
    sha256 "287078d6fb7e1de7c0d46cfa2157eafb59bd28542a490416acde4b6757e239d9" => :high_sierra
    sha256 "6dad799b7ed71c0e48446c539ccec462612d7c170873cd4e1a58aeaa66e4d8a8" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
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
