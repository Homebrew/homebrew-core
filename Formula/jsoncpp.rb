class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/1.7.7.tar.gz"
  sha256 "087640ebcf7fbcfe8e2717a0b9528fff89c52fcf69fa2a18cc2b538008098f97"
  head "https://github.com/open-source-parsers/jsoncpp.git"

  bottle do
    cellar :any
    sha256 "93696fcac79a12aae638802d81f549c7ab76d851c03e49a9c5d2f46b01bf54fb" => :sierra
    sha256 "346280263b59125939e0c12389504441bdab02787543ff1d9b60de2999c92ac0" => :el_capitan
    sha256 "aa63e8bc13ff94c670a956a81966d763b3f3caf67ae4487ccfed98dffffdb2a0" => :yosemite
  end

  option :universal

  needs :cxx11

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    cmake_args = std_cmake_args + %W[
      -DBUILD_STATIC_LIBS=ON
      -DBUILD_SHARED_LIBS=ON
      -DJSONCPP_WITH_CMAKE_PACKAGE=ON
      -DJSONCPP_WITH_TESTS=OFF
      -DJSONCPP_WITH_POST_BUILD_UNITTEST=OFF
    ]
    if build.universal?
      ENV.universal_binary
      cmake_args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end
    system "cmake", ".", *cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <json/json.h>
      int main() {
        Json::Value root;
        Json::Reader reader;
        return reader.parse("[1, 2, 3]", root) ? 0: 1;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                  "-I#{include}/jsoncpp",
                  "-L#{lib}",
                  "-ljsoncpp"
    system "./test"
  end
end
