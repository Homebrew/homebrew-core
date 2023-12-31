class Cjson < Formula
  desc "Ultralightweight JSON parser in ANSI C"
  homepage "https://github.com/DaveGamble/cJSON"
  url "https://github.com/DaveGamble/cJSON/archive/refs/tags/v1.7.17.tar.gz"
  sha256 "c91d1eeb7175c50d49f6ba2a25e69b46bd05cffb798382c19bfb202e467ec51c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b78dd2e9c8ca113352bb0b7e6defbdc13347f3ea865ff5d36c86fabef29d7e44"
    sha256 cellar: :any,                 arm64_ventura:  "f3ac8cc558b9bf3204f187fc7f97c51cfe3a0fa7f69b6c0ac90ef1cd6f343257"
    sha256 cellar: :any,                 arm64_monterey: "ba43d4860a42c1682366ac6aca8d32cd685e0b5343e3f630e62c3e717dd8c4a8"
    sha256 cellar: :any,                 sonoma:         "fc19335348f155fbbbf8e4a0f723498343b4150da2f87f9ba83187ac22851f26"
    sha256 cellar: :any,                 ventura:        "ce47f24d395a421c7d32c768aa90953a8c9e4b117df89e8866a8014844f24bfe"
    sha256 cellar: :any,                 monterey:       "46d60602f246f016a3b4cf9c70d616542f17862fe00ef0f2a8494ccf4347b934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc741db82146cf729a3efe8876c76120627fe5ce702b8c8be9485e009063ca4b"
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
