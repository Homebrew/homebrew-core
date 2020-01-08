class Libtins < Formula
  desc "C++ network packet sniffing and crafting library"
  homepage "https://libtins.github.io/"
  url "https://github.com/mfontanini/libtins/archive/v4.2.tar.gz"
  sha256 "a9fed73e13f06b06a4857d342bb30815fa8c359d00bd69547e567eecbbb4c3a1"
  revision 1
  head "https://github.com/mfontanini/libtins.git"

  bottle do
    cellar :any
    sha256 "3f7acd9f9ad201779e53014a1f234fe2620bcc66715bc691adae0ec05ce7922a" => :catalina
    sha256 "024927515d79136857d24cde994b1165813a6924163dec87e1171dcf1088431f" => :mojave
    sha256 "acd621b885b5d2e090e2065733cea3e4dcb3c635c42e02c1fc8c0a44148777d0" => :high_sierra
    sha256 "9709befe28f8aeb4052be1304fe642f2d10701a0ef1ac11392239c4081b0e424" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    doc.install "examples"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <tins/tins.h>
      int main() {
        Tins::Sniffer sniffer("en0");
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-ltins", "-o", "test"
  end
end
