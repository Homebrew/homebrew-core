class Cjson < Formula
  desc "Ultralightweight JSON parser in ANSI C"
  homepage "https://github.com/DaveGamble/cJSON"
  url "https://github.com/DaveGamble/cJSON/archive/v1.7.16.tar.gz"
  sha256 "451131a92c55efc5457276807fc0c4c2c2707c9ee96ef90c47d68852d5384c6c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "5e917935bb9f6d66e4c080d14d3d3d4a9d77ff6839e0f97c0be18778bd4ed060"
    sha256 cellar: :any,                 arm64_ventura:  "86ee096088caae2433c9f85afa172a6aef245fdf6ce9fcf9ff352702fe2000a6"
    sha256 cellar: :any,                 arm64_monterey: "f1b4e9f60327ba7e9eb14560bb79483ac417724c20563079d302dbf2d01ebcc0"
    sha256 cellar: :any,                 arm64_big_sur:  "679191a14c283a9d5c4169e25845815608b91a5c9a32a656bcb48fd47072d4a5"
    sha256 cellar: :any,                 sonoma:         "4918ffa1ece97c80450a11c65bbaf2d5ceae0650382183147014f72a544bdc40"
    sha256 cellar: :any,                 ventura:        "3f08bd5fbd91e65ae011c7de3b9f91d4b853a4238e5a204311f346047c67aece"
    sha256 cellar: :any,                 monterey:       "945bbf9662147b825b0b40e4859ab4c7125e3735a360bcd063e80e23b1784076"
    sha256 cellar: :any,                 big_sur:        "67370802349999b8861bdca4607b5e7ac0ddef44d43677e38fa04ddcc2610068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcb8cd8c65d5b5930c06e08e8a4908dadfc5371ae19471bbabea68155054c196"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_CJSON_UTILS=ON",
                    "-DENABLE_CJSON_TEST=Off",
                    "-DBUILD_SHARED_AND_STATIC_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <cjson/cJSON.h>

      int main()
      {
        char *s = "{\\"key\\":\\"value\\"}";
        cJSON *json = cJSON_Parse(s);
        if (!json) {
            return 1;
        }
        cJSON *item = cJSON_GetObjectItem(json, "key");
        if (!item) {
            return 1;
        }
        cJSON_Delete(json);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcjson", "-o", "test"
    system "./test"
  end
end
