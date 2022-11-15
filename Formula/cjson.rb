class Cjson < Formula
  desc "Ultralightweight JSON parser in ANSI C"
  homepage "https://github.com/DaveGamble/cJSON"
  url "https://github.com/DaveGamble/cJSON/archive/v1.7.15.tar.gz"
  sha256 "5308fd4bd90cef7aa060558514de6a1a4a0819974a26e6ed13973c5f624c24b2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ad434259c62a12cf5b5dbfc725214ae5dd4f49edc293e09f36d757f7832ec8e3"
    sha256 cellar: :any,                 arm64_monterey: "6e0051098016dfe778b578304a46af1a7e171c04abb9e507945b069bfe771d74"
    sha256 cellar: :any,                 arm64_big_sur:  "5cee282ea9e05f687010993884e90b1f89980af0909fe2f8c376d520cb3a1cd7"
    sha256 cellar: :any,                 ventura:        "6faecacb90ee0e3149c329d71d8bcb3cea5fc0bb3da3b8258e54285a7fb02050"
    sha256 cellar: :any,                 monterey:       "821879ddb86f12b2fa764e3bf1f094eea1d19bff8924f4b3ec3ff1a1aeac40ed"
    sha256 cellar: :any,                 big_sur:        "6a836d6f194756f36b0007b1c9bb8881c8bec86f41b9987a436524d1b2c66271"
    sha256 cellar: :any,                 catalina:       "523569912fcfe553fa50f9b856a3de0bbca49d573d750c44a9ed08af01eb8606"
    sha256 cellar: :any,                 mojave:         "13b34d77585c933b3d22c8b060fcc67758f38bfe6422ede3e312b0079d2b7476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50eda10d20f7d2c51b32dad782185f38ba97fb5794c5902edf50c22167f4e2e2"
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
    system ENV.cc, "test.c", "-L#{lib}", "-lcjson", "-o", "test"
    system "./test"
  end
end
