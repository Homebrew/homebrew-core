class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://libjwt.io/"
  url "https://github.com/benmcollins/libjwt/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "7af71a58aa4b3ebd487361000c80191624a07883436cb1b5f5303488f29778ec"
  license "MPL-2.0"
  head "https://github.com/benmcollins/libjwt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "cbc81ceb89c407e364de0c2e5401a307f6e23f7baedda39f8027954412d251bf"
    sha256 cellar: :any, arm64_golden_gate: "6049ce8a9026f5e9f625fc971b1fefb33094e7704826ab10fab5d7a8312cf741"
    sha256 cellar: :any, arm64_tahoe:       "286fe3134fb2f276422922c54b037cc61b8fc1e8b9155cdcf4522792d65d23b3"
    sha256 cellar: :any, arm64_sequoia:     "150c7297d7eae2afccd6f5a3f6cb76d4c6b5cd17148d1d5f04c8aad735354349"
    sha256 cellar: :any, arm64_linux:       "7e69cb531d54edd592e91269bbf546966450beec0521773c194122ccc60925ce"
    sha256 cellar: :any, x86_64_linux:      "3fc8f75dfad10d4fcf5c76c6014f9a0cd1097946ea99ab328533e3f5369f2b8a"
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
