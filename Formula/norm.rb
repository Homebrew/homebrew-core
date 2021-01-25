class Norm < Formula
  desc "NACK-Oriented Reliable Multicast"
  homepage "https://www.nrl.navy.mil/itd/ncs/products/norm"
  url "https://github.com/USNavalResearchLaboratory/norm/archive/v1.5.8.tar.gz"
  sha256 "ee7493c9ae9a129e7cbcd090a412fb0d0e25ab3acaa4748e5dc696bf822a62b5"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "0d223adbb36c557616fbb8e026e93a36603ff5478ea3912978190389e409b04a" => :big_sur
    sha256 "658241c3120a66b68191f64e4009617d9ee0e43c5cd264e0db59f9dd2aeca966" => :arm64_big_sur
    sha256 "b01566af6d67555366f350e72a9717479c1510af885a89b60827356aeba7d2af" => :catalina
    sha256 "bc9f51046dc479949b480bb9a27143679bccb5f4bab0928c5968d280f9489d86" => :mojave
    sha256 "c46470e7594148cbee61f851b57373374abdc6a94e91c722efabd3c90f36ec06" => :high_sierra
  end

  resource "protolib" do
    url "https://github.com/USNavalResearchLaboratory/protolib/archive/v3.0b1.tar.gz"
    sha256 "1e15bbbef4758e0179672d456c2ad2b2087927a3796adc4a18e2338f300bc3e6"
  end

  def install
    (buildpath/"protolib").install resource("protolib")

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "install"
    include.install "include/normApi.h"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <normApi.h>

      int main()
      {
        NormInstanceHandle i;
        i = NormCreateInstance(false);
        assert(i != NORM_INSTANCE_INVALID);
        NormDestroyInstance(i);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lnorm", "-o", "test"
    system "./test"
  end
end
