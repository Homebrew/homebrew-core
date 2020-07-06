class Cjson < Formula
  desc "Ultralightweight JSON parser in ANSI C"
  homepage "https://github.com/DaveGamble/cJSON"
  url "https://github.com/DaveGamble/cJSON/archive/v1.7.13.tar.gz"
  sha256 "d4e77a38f540f2c37f55758f2666655314f1f51c716fea5f279659940efdcf04"
  license "MIT"

  bottle do
    cellar :any
    sha256 "082bbc54aa1bf574900bc7ee017435d01888fd854953c6de1a6d62124fcd5306" => :catalina
    sha256 "71a46c6fb3f06ed82cbb3009b5daed3b1083c6e7240760230ba900cb80267912" => :mojave
    sha256 "76bde53a90ac3e1d62ae20283170392948bfce48046c6204e1114c1624dfa4aa" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-DENABLE_CJSON_UTILS=On", "-DENABLE_CJSON_TEST=Off",
                    "-DBUILD_SHARED_AND_STATIC_LIBS=On", ".",
                    *std_cmake_args
    system "make", "install"
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
    system ENV.cc, "-L#{lib}", "-lcjson", "test.c", "-o", "test"
    system "./test"
  end
end
