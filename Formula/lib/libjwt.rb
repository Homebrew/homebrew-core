class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://libjwt.io/"
  url "https://github.com/benmcollins/libjwt/archive/refs/tags/v3.6.4.tar.gz"
  sha256 "08df4acca3d2ca76d4c557a896179a9d44cd4b5fe7003c336e4a56f68c43f685"
  license "MPL-2.0"
  head "https://github.com/benmcollins/libjwt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "60f51c6ade9b76f980fe7c2053ca43293269baed3a89104474b8b09dcbc27041"
    sha256 cellar: :any, arm64_tahoe:       "0403d4d576838e5089985f70b0706345bbe443bd1909c4df6bd07379266c1337"
    sha256 cellar: :any, arm64_sequoia:     "67e7fe0ac5665dc94fadeb36e805d80c573c0b4b0ffa0e1c826c3bc72d7a12db"
    sha256 cellar: :any, arm64_linux:       "dc85997cf2fec411a9f5f2f5dcf97e018b280412333b9dc68cf489f70d07053d"
    sha256 cellar: :any, x86_64_linux:      "d525fbce0796e5eb6fab814e046a58aadb7ced40e5b2e85896c1ed799696c7d9"
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
