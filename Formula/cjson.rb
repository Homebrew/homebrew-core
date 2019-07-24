class Cjson < Formula
  desc "Ultralightweight JSON parser in ANSI C"
  homepage "https://github.com/DaveGamble/cJSON"
  url "https://github.com/DaveGamble/cJSON/archive/v1.7.12.tar.gz"
  sha256 "760687665ab41a5cff9c40b1053c19572bcdaadef1194e5cba1b5e6f824686e7"

  bottle do
    cellar :any
    sha256 "6e671c987bed5cd4d77fdb012b59188a0a259c56748b5e5468e69a08057af7ac" => :mojave
    sha256 "8faa88b998afebbc44c28b75b437fff916a1abf03d0354b17bae76a7682b267e" => :high_sierra
    sha256 "680e8dbe6689f0107e4f54420fdc06e97d662c8af31956c9264c48e1db215c52" => :sierra
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
