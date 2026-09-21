class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://libjwt.io/"
  url "https://github.com/benmcollins/libjwt/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "b483a5f77e548964553f54a0ec5f0c810cc6c0629c5ac5a03610bcced150e7be"
  license "MPL-2.0"
  head "https://github.com/benmcollins/libjwt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "f6f093d1844379197330cdd7848bd130c3f2d3d516c4849b8b2aa4503207d0ac"
    sha256 cellar: :any, arm64_tahoe:       "cea180d3a620bee3e9d57c421d7d6b3d5323ae50a6a6ae16da8675fc22f60300"
    sha256 cellar: :any, arm64_sequoia:     "6ff0d3d51daa751ee1ef30c19072b42cf53e281b1f1d356bc505d9b804999042"
    sha256 cellar: :any, arm64_sonoma:      "277a593fe23a1b1450a4a5a93e9306daef9b7d99ad24b0f4f6974dbde2d20915"
    sha256 cellar: :any, arm64_linux:       "07b4955d42e1b1fa82e7f910e2a0f08ab94b3b30581b636ae6882473710f02a5"
    sha256 cellar: :any, x86_64_linux:      "19818bfb277320e56a4824886c08d64a5b94247cb121fec0cda2c4f97de6a06c"
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
