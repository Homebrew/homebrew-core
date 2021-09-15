class Libiptcdata < Formula
  desc "Virtual package provided by libiptcdata0"
  homepage "https://libiptcdata.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libiptcdata/libiptcdata/1.0.4/libiptcdata-1.0.4.tar.gz"
  sha256 "79f63b8ce71ee45cefd34efbb66e39a22101443f4060809b8fc29c5eebdcee0e"
  revision 1

  bottle do
    sha256 arm64_big_sur: "45d61d51cb3e5607763ed374d5cc88e4a7c6dc8b1ba08ccd276c3379a20646bf"
    sha256 big_sur:       "5bb2bce1d8a877c84abb51f3b9d9e0c40588bdeb2d6ea8d66c6de230d2e35e8d"
    sha256 catalina:      "1dbcf1dd89b05f7f1fdc1a15d9c56b7e726f7296d8096ccae22fed9adf36790a"
    sha256 mojave:        "78dc7bb6b1e5bcccc1c0c9ef158b8d423f782aa455b1b10c3eebb29de6e7fa58"
    sha256 high_sierra:   "62f4a032075fbf0b9a43ef474b784bae7c47d503483bdc2e09e851c5568345e3"
    sha256 sierra:        "0a9cd6e750e496cd4eb9797ac34d3659c8dc2bb6977020def1edb2ee60711a39"
    sha256 x86_64_linux:  "4e929a2391eb2733d481f84b82cc925a1d0cf943bed4f99af876f4240b62c9c0"
  end

  depends_on "gettext"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
