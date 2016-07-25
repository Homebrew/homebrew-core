class Jsoncpp < Formula
  desc "Library for interacting with JSON"
  homepage "https://github.com/open-source-parsers/jsoncpp"
  url "https://github.com/open-source-parsers/jsoncpp/archive/1.7.4.tar.gz"
  sha256 "10dcd0677e80727e572a1e462193e51a5fde3e023b99e144b2ee1a469835f769"
  head "https://github.com/open-source-parsers/jsoncpp.git"

  bottle do
    cellar :any
    sha256 "da2352b84b5685a648e30d99194c2601f151a1f2a668ab6d85498977c22971cf" => :el_capitan
    sha256 "33ca9d623e31790bab4773a2169a5f30f9c2e2994fd2ec668ab37887d36f3f80" => :yosemite
    sha256 "bdd8af9fc8a439b0a8d831174cd7f916233461cc295f0e5b9e0878e19a03b6af" => :mavericks
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
