class Libtins < Formula
  desc "C++ network packet sniffing and crafting library"
  homepage "https://libtins.github.io/"
  url "https://github.com/mfontanini/libtins/archive/v4.3.tar.gz"
  sha256 "c70bce5a41a27258bf0e3ad535d8238fb747d909a4b87ea14620f25dd65828fd"
  license "BSD-2-Clause"
  head "https://github.com/mfontanini/libtins.git"

  bottle do
    cellar :any
    sha256 "698edf1fd2794c4bf81e1debcddadf1fcad906f98cde53c7240705578ec3a584" => :catalina
    sha256 "0cc57b006a581a0da50ef3b365f1cbd292e9ae054a552751cc7af3d93860ebce" => :mojave
    sha256 "0a15741675e5c3f65f98fd89a25f0a1167294b95ba596620b63a45ad71dedea8" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    doc.install "examples"

    # Clean up the build file garbage that has been installed.
    rm_r Dir["#{share}/doc/libtins/**/CMakeFiles/"]
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
