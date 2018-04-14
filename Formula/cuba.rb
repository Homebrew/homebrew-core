class Cuba < Formula
  desc "Library for multidimensional numerical integration"
  homepage "http://www.feynarts.de/cuba/"
  url "http://www.feynarts.de/cuba/Cuba-4.2.tar.gz"
  sha256 "6b75bb8146ae6fb7da8ebb72ab7502ecd73920efc3ff77a69a656db9530a5eef"

  def install
    # The Makefile provided does not support parallel build
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "demo"
  end

  test do
    system ENV.cc, "-o", "demo-c", "#{lib}/libcuba.a", "#{pkgshare}/cuba/demo/demo-c.c"
    system "./demo-c"
  end
end
