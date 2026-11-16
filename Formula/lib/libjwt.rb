class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://libjwt.io/"
  url "https://github.com/benmcollins/libjwt/archive/refs/tags/v3.6.3.tar.gz"
  sha256 "f8be7455070d210c9b24e732fbead6150684b3639e58ae7ca522006532c1aca6"
  license "MPL-2.0"
  head "https://github.com/benmcollins/libjwt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9ed4cdbd3233608f9800518aac474bbaa1c54677581517c53b7e4a1f02722808"
    sha256 cellar: :any, arm64_tahoe:       "58a34f7127c3d7be13ee9cd6c1d6800333b8d3fc2788189baf2429200289bef5"
    sha256 cellar: :any, arm64_sequoia:     "570eb5d153b33e8e899e081dd69f82f2c8cedadfd0f8ce13b727c09fb0e1292c"
    sha256 cellar: :any, arm64_linux:       "a5091bb4878d14c8697b7001bd5dca9f685f1e66291b5fb40f78e9416bc23612"
    sha256 cellar: :any, x86_64_linux:      "38a87ec3020fcd82f29610fd39bae29799df35870eece4fbf6beaf64fe992847"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "jansson"
  depends_on "openssl@4"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DWITH_TESTS=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <jwt.h>

      int main(void) {
        jwt_builder_t *builder = jwt_builder_new();
        char *token = jwt_builder_generate(builder);
        free(token);
        jwt_builder_free(builder);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-ljwt", "-o", "test"
    system "./test"
  end
end
