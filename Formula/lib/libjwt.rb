class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://libjwt.io/"
  url "https://github.com/benmcollins/libjwt/archive/refs/tags/v3.3.3.tar.gz"
  sha256 "a562e5548a8e10ac6fcba64a5e6d326c15712211cb54d25242c15e8b3250b4f2"
  license "MPL-2.0"
  head "https://github.com/benmcollins/libjwt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "07179f355e1f88d33ba8d15c97cd33670c9a8f37b36d3d702ea7150a37ef8e56"
    sha256 cellar: :any,                 arm64_sequoia: "70e47ae8720a2bd8dd5c5dae002a078424d1957bef3624b7f1d0c5b2039c62bd"
    sha256 cellar: :any,                 arm64_sonoma:  "6f798eb68dfe617f54728c86106efccb6014db02e52f55d7745199df4bc3c6c9"
    sha256 cellar: :any,                 sonoma:        "9ab63d572d73ede9c4e209291d71836dc3828a03f941794c1df1e383b01120c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "485768794b70ea2045f4a74232d6e5a1726779f1e18aa2e61648311638dc246c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00d04ad57252c93f49ef409974364811825141e79c87a798eec1b64b7aa045d4"
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
