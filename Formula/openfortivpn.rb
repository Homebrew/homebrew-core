class Openfortivpn < Formula
  desc "Open Fortinet client for PPP+SSL VPN tunnel services"
  homepage "https://github.com/adrienverge/openfortivpn"
  url "https://github.com/adrienverge/openfortivpn/archive/v1.4.0.tar.gz"
  sha256 "3b5ddbf4c0aecc85e9630bb45e012f7e0b0db5a10276f03f8af55326db97d9b4"

  bottle do
    sha256 "963a3fc10840236356c5784c6095a294cca13e11d6aed7299bdb552178838fe9" => :sierra
    sha256 "24cd6e25784cdda7c03b6cd40d7a72da641964c65e97c5a3da0fdbbac826d72e" => :el_capitan
    sha256 "8cf55b96020ddc6328999be0e92d0409b81985bcfb0c22e1db975cf8b8bb7955" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "openssl"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    system bin/"openfortivpn", "--version"
  end
end
