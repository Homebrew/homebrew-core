class Json11 < Formula
  desc "Tiny JSON library for C++11"
  homepage "https://github.com/dropbox/json11"
  url "https://github.com/dropbox/json11/archive/v1.0.0.tar.gz"
  sha256 "bab960eebc084d26aaf117b8b8809aecec1e86e371a173655b7dffb49383b0bf"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "35c418041e5f90e2f6486b6ae047fc72166356082618940a319f85ac4939aa8b" => :big_sur
    sha256 "9b05e1c86fa167507521019951abafe352ab7ec786c9227d7816d860e5b370d8" => :arm64_big_sur
    sha256 "cbdc55d054d0ba3060a8709b5b98c5c4c0601e7483b4ca2a62aab8a9fc630428" => :catalina
    sha256 "e0229fc7e70a26fdd945e3cf666e2608f73d186b20fcc2555d19466e78771d54" => :mojave
  end

  deprecate! date: "2020-11-27", because: :repo_archived

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <json11.hpp>
      #include <string>
      using namespace json11;

      int main() {
        Json my_json = Json::object {
          { "key1", "value1" },
          { "key2", false },
          { "key3", Json::array { 1, 2, 3 } },
        };
        auto json_str = my_json.dump();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                    "-ljson11", "-o", "test"
    system "./test"
  end
end
