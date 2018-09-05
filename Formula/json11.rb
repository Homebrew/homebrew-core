class Json11 < Formula
  desc "Tiny JSON library for C++11"
  homepage "https://github.com/dropbox/json11"
  url "https://github.com/dropbox/json11/archive/v1.0.0.tar.gz"
  sha256 "bab960eebc084d26aaf117b8b8809aecec1e86e371a173655b7dffb49383b0bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa88a6f0691e52c7b7830f08287c3c8379337b66694161175ec85f1ded4b40ae" => :mojave
    sha256 "3c6b7776a4702bb90d046f3c6f4ace063ea04d3355c7ce51127824292cb4506f" => :high_sierra
    sha256 "e7a717f73162477010c156c2e4d281bb4b5f26ea3c53a5aaffc82998954d119c" => :sierra
    sha256 "d5345ad5224fb7aeda2562d1a46350c44f66cf98486d142bc81b8186e5aa74cc" => :el_capitan
  end

  depends_on "cmake" => :build

  needs :cxx11

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
