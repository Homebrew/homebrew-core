class Polyml < Formula
  desc "Standard ML implementation"
  homepage "https://www.polyml.org/"
  url "https://github.com/polyml/polyml/archive/v5.8.tar.gz"
  sha256 "6bcc2c5af91f361ef9e0bb28f39ce20171b0beae73b4db3674df6fc793cec8bf"
  head "https://github.com/polyml/polyml.git"

  bottle do
    sha256 "7d004ce1e0cd9920cc0d66a690be780e11365f8725bbfaa68222ddf324d1d0f8" => :mojave
    sha256 "11835db3f5848077c9b0e6af52bceffaf4c356892c9e3dc795976bcf9711a06b" => :high_sierra
    sha256 "b3dd5bae8d8cef36c6258c2620a4ae894a7a1c66fe56330c48e19a1f81aa66d9" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
