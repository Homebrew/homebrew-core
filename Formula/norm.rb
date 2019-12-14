class Norm < Formula
  desc "NACK-Oriented Reliable Multicast"
  homepage "https://www.nrl.navy.mil/itd/ncs/products/norm"
  url "https://github.com/USNavalResearchLaboratory/norm/archive/v1.5.8.tar.gz"
  sha256 "ee7493c9ae9a129e7cbcd090a412fb0d0e25ab3acaa4748e5dc696bf822a62b5"

  bottle do
    cellar :any
    sha256 "33fe80265196bcb17409ab524723c4dd3035862e3c4d0372bca8c5f56cd0b24b" => :mojave
    sha256 "253fcd48d81db23132b15a295ef822f5d9f02f13a79ff4e906ad7381ca418bc7" => :high_sierra
    sha256 "a23a43d211bccabe0df629618f53acf41d6250d1fc85111397d769f007d30b9f" => :sierra
    sha256 "985bbdc34e0f8f16f2d377bea4c0442abb0f7cbaf67b56cb40b924bb09c394b5" => :el_capitan
    sha256 "2c165178bfce5879bb6e031b4d54f741cad2868d67b03783f89a13d15503f28d" => :yosemite
    sha256 "b5f802ff09e68b712f472f45aea9b634f6c45868bccaf708d565ff98a95b145e" => :mavericks
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
