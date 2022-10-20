class Json11 < Formula
  desc "Tiny JSON library for C++11"
  homepage "https://github.com/dropbox/json11"
  url "https://github.com/dropbox/json11/archive/v1.0.0.tar.gz"
  sha256 "bab960eebc084d26aaf117b8b8809aecec1e86e371a173655b7dffb49383b0bf"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "812394b65215fb60f32f3b82697483a928e1784ea981fd3948ed07aae93e12fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b05e1c86fa167507521019951abafe352ab7ec786c9227d7816d860e5b370d8"
    sha256 cellar: :any_skip_relocation, monterey:       "07fe8500710d83ca7e6bc1b8cc3b081fbcc6ad45363bdd3bd346c42f712cf926"
    sha256 cellar: :any_skip_relocation, big_sur:        "35c418041e5f90e2f6486b6ae047fc72166356082618940a319f85ac4939aa8b"
    sha256 cellar: :any_skip_relocation, catalina:       "cbdc55d054d0ba3060a8709b5b98c5c4c0601e7483b4ca2a62aab8a9fc630428"
    sha256 cellar: :any_skip_relocation, mojave:         "e0229fc7e70a26fdd945e3cf666e2608f73d186b20fcc2555d19466e78771d54"
  end

  disable! date: "2022-07-31", because: :repo_archived

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
