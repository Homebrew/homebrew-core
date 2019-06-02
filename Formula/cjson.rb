class Cjson < Formula
  desc "Ultralightweight JSON parser in ANSI C"
  homepage "https://github.com/DaveGamble/cJSON"
  url "https://github.com/DaveGamble/cJSON/archive/v1.7.12.tar.gz"
  sha256 "760687665ab41a5cff9c40b1053c19572bcdaadef1194e5cba1b5e6f824686e7"

  depends_on "cmake" => :build

  def install
    system "cmake", "-DENABLE_CJSON_UTILS=On", "-DENABLE_CJSON_TEST=Off", ".",
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
