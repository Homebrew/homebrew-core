class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://libjwt.io/"
  url "https://github.com/benmcollins/libjwt/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "d521d7fbf0794afa1bed4c806cda26fd5cf7991d7b6a5cec0274dccc6891288a"
  license "MPL-2.0"
  head "https://github.com/benmcollins/libjwt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f8ca1d10699030a15bb0e310a8be28dcf9b16a1b36707702044201c4c23f712b"
    sha256 cellar: :any, arm64_tahoe:       "c4f1a348b5a6b007fd3d3893f904a69f3297335daf396e1d418948e99d7f6a18"
    sha256 cellar: :any, arm64_sequoia:     "a11ad9b17712b5dce0e54b001b3e0802f6dc8e23496230b27caa7bdf0d467059"
    sha256 cellar: :any, arm64_linux:       "963d5b430454c9ea12c99f441bc3016ae6136dea63a1fc89f356054900d1dd47"
    sha256 cellar: :any, x86_64_linux:      "f7370d12362732f9cb96e7a7a6da97595fbeddf425ee1a18b383ed425f2f2405"
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
