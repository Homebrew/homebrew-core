class Libtins < Formula
  desc "C++ network packet sniffing and crafting library"
  homepage "https://libtins.github.io/"
  url "https://github.com/mfontanini/libtins/archive/v4.2.tar.gz"
  sha256 "a9fed73e13f06b06a4857d342bb30815fa8c359d00bd69547e567eecbbb4c3a1"
  revision 1
  head "https://github.com/mfontanini/libtins.git"

  bottle do
    cellar :any
    sha256 "41eb18ba89ba9c6257b15343a3dc2bef338935fe62d917bcae33ed439dee88c7" => :mojave
    sha256 "8a72071c4c6b5a396b3eedd3a40dc7dd558cdeadda21f9233f968ffa55aff134" => :high_sierra
    sha256 "ccaa57c2fb78a1344033d3d571ac95dd44c34cd2cee7e98f1594766e45d573ad" => :sierra
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
