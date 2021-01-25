class Cjson < Formula
  desc "Ultralightweight JSON parser in ANSI C"
  homepage "https://github.com/DaveGamble/cJSON"
  url "https://github.com/DaveGamble/cJSON/archive/v1.7.14.tar.gz"
  sha256 "fb50a663eefdc76bafa80c82bc045af13b1363e8f45cec8b442007aef6a41343"
  license "MIT"

  bottle do
    cellar :any
    sha256 "9d85bfec25eec9244a4e99807bcb976b72afd47e3c740f37f3d7033b910d6abc" => :big_sur
    sha256 "1fa282ceccaeb65e3af86a5787cc5ff413ce6b97ecca802c9c562b85b1850804" => :arm64_big_sur
    sha256 "19da0211d4aabe7a2bf7cf489682d8a9ec57f7d5749cdd39f81491354017a9b9" => :catalina
    sha256 "32192c80f7a8dea4988342342dd80aabba292e8200e52f9cd2a2a35fc202b671" => :mojave
    sha256 "0dfc85831529da5d33e07b46c08fbca4ed673f3879c4025a982b7612a0a05b7c" => :high_sierra
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
