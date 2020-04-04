class Cjson < Formula
  desc "Ultralightweight JSON parser in ANSI C"
  homepage "https://github.com/DaveGamble/cJSON"
  url "https://github.com/DaveGamble/cJSON/archive/v1.7.13.tar.gz"
  sha256 "d4e77a38f540f2c37f55758f2666655314f1f51c716fea5f279659940efdcf04"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b402e60f6a786780c9739b91845c2f8df2ea60ce8749e42db11cbcc5f86bb52a" => :catalina
    sha256 "3364af8e12165cfd7721e8d64e1a4ee021a2fe2fc64b09726a8624f262d8449f" => :mojave
    sha256 "f8a92b03d0ff1147d604517317366706e93cb398ffa8e208b84b4bd91282231e" => :high_sierra
    sha256 "be61141bcc7cd3706051ead5a2158b7a92f840e0802f745e4c53052a82616d55" => :sierra
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
