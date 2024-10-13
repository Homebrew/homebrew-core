class Cjson < Formula
  desc "Ultralightweight JSON parser in ANSI C"
  homepage "https://github.com/DaveGamble/cJSON"
  url "https://github.com/DaveGamble/cJSON/archive/refs/tags/v1.7.18.tar.gz"
  sha256 "3aa806844a03442c00769b83e99970be70fbef03735ff898f4811dd03b9f5ee5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "369cf21b89c82a4f1834fb3c8a128f5bf970f22bbb13376652448fbde998dad9"
    sha256 cellar: :any,                 arm64_sonoma:   "6deee0399f8b92240122c7cb8dee5a3f3e7b26f9cec147b9d0baffb3c6a804dc"
    sha256 cellar: :any,                 arm64_ventura:  "f8cd3c29957ec2a1007c52197f924e7f5262da5809bf928a451b25ea95df5203"
    sha256 cellar: :any,                 arm64_monterey: "8dbfc2c100bf1710e3cbc477526e3ba5694f0b1162452252932d4c6ed2ea8a9f"
    sha256 cellar: :any,                 sonoma:         "1b0c17ed9045b0feb0ba140a31ab247876055ac753cd1fe1d55c0e9fc334e332"
    sha256 cellar: :any,                 ventura:        "d9587b4d465d2fb40c4cfc6a7c843a97fc9f0aef817b036ffd7418b10cbdd6d1"
    sha256 cellar: :any,                 monterey:       "5173b927f124a5e5f1cdc8c9625e41b91d489f779837e59e245b9fae38b36cc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ad376a8e59ceadee7ca6ec2ba000a8d1b5359a38e964afb3ca05fed166294da"
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
