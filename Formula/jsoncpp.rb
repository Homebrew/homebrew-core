class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/1.8.0.tar.gz"
  sha256 "5deb2462cbf0c0121c9d6c9823ec72fe71417e34242e3509bc7c003d526465bc"
  head "https://github.com/open-source-parsers/jsoncpp.git"

  bottle do
    cellar :any
    sha256 "979f26dae212b696ea1f0fe37e022e07ef1d9c6e5a300abe66e79ded804eb6bf" => :sierra
    sha256 "b418b5afee4f4decd68291e2a17b5a6a3583c9c97fb66c57bb5b4fb3c573c802" => :el_capitan
    sha256 "9f33d38dc6d459622705c4982204e0eea49a5d9a14440a032695dd1b72214cad" => :yosemite
  end

  option :universal

  needs :cxx11

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    cmake_args = std_cmake_args + %w[
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
