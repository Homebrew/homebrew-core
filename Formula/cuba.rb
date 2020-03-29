class Cuba < Formula
  desc "Library for multidimensional numerical integration"
  homepage "http://www.feynarts.de/cuba/"
  url "http://www.feynarts.de/cuba/Cuba-4.2.tar.gz"
  sha256 "da4197a194f7a79465dfb2c06c250caa8e76d731e9d6bdfd2dd6e81c8fc005e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd3e744e7357b51f502a8241360df6f29ecfe74a8d33dad2503ab64528e99573" => :catalina
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
