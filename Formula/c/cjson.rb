class Cjson < Formula
  desc "Ultralightweight JSON parser in ANSI C"
  homepage "https://github.com/DaveGamble/cJSON"
  url "https://github.com/DaveGamble/cJSON/archive/refs/tags/v1.7.19.tar.gz"
  sha256 "7fa616e3046edfa7a28a32d5f9eacfd23f92900fe1f8ccd988c1662f30454562"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3949c4efc1e2bb3de33dff83f7bb3322465f4e459b05b9c8ecafb50f9589453a"
    sha256 cellar: :any,                 arm64_sequoia: "02864d4e743d0b31edf050ab99325b77cbd34bde4a0fee2258c4903fb7cac621"
    sha256 cellar: :any,                 arm64_sonoma:  "a55942b2cb916d0ee9e84a1d658ba2b71915296e5e9a943fb1b9f99e73449a27"
    sha256 cellar: :any,                 arm64_ventura: "ca30e93594455cda8c6d73e1b409a0b7cb71b294d6044d5d58ea0bb6e088b648"
    sha256 cellar: :any,                 sonoma:        "38330ec91289eb1a460d5f0db4bdf61dd897d919fd1bd217eb2fd0fdf7c11fe3"
    sha256 cellar: :any,                 ventura:       "4c462770205bcd357dc350b46f6a5a3ef62f4ddf34a13d10b4064eaa57389f94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3110d0581424dd08bfe03086bc2325c6c0a6610486e4f18f3453bd36d9fb36c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26f2f08e3a78ef1026622802b4147d2ba47c6ae9df9114d68343c55d6fd63183"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DENABLE_CJSON_UTILS=ON
      -DENABLE_CJSON_TEST=Off
      -DBUILD_SHARED_AND_STATIC_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lcjson", "-o", "test"
    system "./test"
  end
end
