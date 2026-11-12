class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://libjwt.io/"
  url "https://github.com/benmcollins/libjwt/archive/refs/tags/v3.6.2.tar.gz"
  sha256 "df794f41c1310fb96e3d45b6fc034ea9fbaf619b631c43bd86ff64dd597d33c4"
  license "MPL-2.0"
  head "https://github.com/benmcollins/libjwt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7801c86ed38def1af8feac00258cf6056dc9056b53ba695ae4a76097757d30d9"
    sha256 cellar: :any, arm64_tahoe:       "4592d72fabd5c5494a9c6f744c677481e1306d8c2b1a23b85523fdb39664536c"
    sha256 cellar: :any, arm64_sequoia:     "7ab3807d277316bc69a97ab050bd330be4fa3983c7fef426e2c5cca16a0661b6"
    sha256 cellar: :any, arm64_linux:       "43db8c89e52d6b260a79a4692d2d72575ffce56d734fb8f129b2ddcab259e5bf"
    sha256 cellar: :any, x86_64_linux:      "e8929f0133fc48e6f3528840b1dfa9840f1ae17a5ca03c8f10554707c174a397"
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
