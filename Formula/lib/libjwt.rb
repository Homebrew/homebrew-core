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
    sha256 cellar: :any, arm64_tahoe:   "b586af46bba3526ae59669856ec8d782681169a5f068ec2a07347280a477aa3e"
    sha256 cellar: :any, arm64_sequoia: "023b65d38408089268a44c4326aadd68f5973a76d9c068e9c15627d32d588699"
    sha256 cellar: :any, arm64_sonoma:  "48f1635bc477be3196b72cc1774277450a624836937f891a07e84fb73acc7d72"
    sha256 cellar: :any, sonoma:        "e476cba0594dd05358eaab4e1013bfc14324640aafe9434d057203d894381c33"
    sha256 cellar: :any, arm64_linux:   "3049cfd013f9bd7e554d4d4e339e155caa6bd4abf4daa48c1b3a9c6cb77c8012"
    sha256 cellar: :any, x86_64_linux:  "9c4716bccba03602ab2d9a22f4c93d80c6b4794147e20ae31b40e4a690531cbd"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DWITH_TESTS=OFF", *std_cmake_args
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
