class Bro < Formula
  desc "Network security monitor"
  homepage "https://www.bro.org"
  url "https://www.bro.org/downloads/bro-2.5.3.tar.gz"
  sha256 "7384fa14e6cebc86488040877fc0bfd50868e969f0fa05178cef0116e4116225"
  head "https://github.com/bro/bro.git"

  bottle do
    sha256 "8f3c784b66fb018db6606e27cb02099c792a4e531678fc2b4f29f8614f15a660" => :high_sierra
    sha256 "3c5756e18c683ab3898e849b5e94f4cac25c487de6a9f2a89c7fd20751e58825" => :sierra
    sha256 "b71f2ab1666612dda2ba7706177781a15087151b89a15df055c5978e4746959e" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "openssl"
  depends_on "geoip" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}",
                          "--localstatedir=#{var}",
                          "--conf-files-dir=#{etc}"
    system "make", "install"
  end

  test do
    system "#{bin}/bro", "--version"
  end
end
