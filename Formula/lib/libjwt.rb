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
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "61773960bcdf648e9ca898014d174d06892a040c24af12c257fb5069cf2ffa13"
    sha256 cellar: :any, arm64_sequoia: "16500fd9d18377e8abdb79126639f58a9a85098e8960710717aa14204f8e8143"
    sha256 cellar: :any, arm64_sonoma:  "36b4976416aa72340a3713494eb505a5734bfa002057c00216eadac413ecd52a"
    sha256 cellar: :any, sonoma:        "3bca716a62e7011009c45c2d3b1ef0b737e2060d1989c164237bc6c56bad56a3"
    sha256 cellar: :any, arm64_linux:   "282bb91e8bb37caf6c2e99aaf1a79c8163e7459fe97b839e25716edb43cc2dc9"
    sha256 cellar: :any, x86_64_linux:  "71911a4882b10f56d58dc36f820be5ad41c50e7ce3a2cf7cf82341a5dde8804f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "jansson"
  depends_on "openssl@3"

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
