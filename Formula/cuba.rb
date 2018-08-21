class Cuba < Formula
  desc "Library for multidimensional numerical integration"
  homepage "http://www.feynarts.de/cuba/"
  url "http://www.feynarts.de/cuba/Cuba-4.2.tar.gz"
  sha256 "6b75bb8146ae6fb7da8ebb72ab7502ecd73920efc3ff77a69a656db9530a5eef"

  bottle do
    cellar :any_skip_relocation
    sha256 "4520616f7170177dd546ec6d71d3c52e592c93e8a7e24b9c2e252382011a7b4d" => :mojave
    sha256 "a607f8cbcfa954ac20a407fce07dc6cc65bfaab6b06079cc5d1eb85400532e74" => :high_sierra
    sha256 "b3317c5c1d2f902d60aaa175f3e35d906f2ac6ab179b87de09e0f9110125b4ff" => :sierra
    sha256 "6f1bf18403892cea4d5d692256e31dd11d170ecadaf996f960c454084e51b243" => :el_capitan
  end

  def install
    ENV.deparallelize # Makefile does not support parallel build
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "demo"
  end

  test do
    system ENV.cc, "-o", "demo", "-L#{lib}", "-lcuba",
                   "#{pkgshare}/demo/demo-c.c"
    system "./demo"
  end
end
