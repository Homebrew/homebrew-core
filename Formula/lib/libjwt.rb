class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://libjwt.io/"
  url "https://github.com/benmcollins/libjwt/releases/download/v3.2.1/libjwt-3.2.1.tar.xz"
  sha256 "b7800a6b085855690b401b41dbdf0bcb49207d5fe43c13abbdc8106c16a9250c"
  license "MPL-2.0"
  head "https://github.com/benmcollins/libjwt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2819ec3a3adfc26a3211bad2a92fd63e82288e9eb6f46670d29f95cb2d68fe25"
    sha256 cellar: :any,                 arm64_sonoma:  "9d00c6b506e1f368e5e3ccf4cf7e6b3971c983d85b8a829a5f70aae20790d879"
    sha256 cellar: :any,                 arm64_ventura: "a3e9b7bc0361f1f6726ea8863f7fa4f1793f7fcbfab11bd88e66c6e894339d31"
    sha256 cellar: :any,                 sonoma:        "78d16019a3009299578e2a6cfbe9f09950d534379f37b6e990da35b95d3ac14f"
    sha256 cellar: :any,                 ventura:       "c87231ba166ec2339d045a88dbd17be3f54a66df254d7e1d67bb9b80d03599a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "852d7b446652b256221c6cc279838ea377cd1b3d2a2fe706b73577a843320c1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a2f1f5567817e4d996c654b63a80236beedce4c221060d551d184c9780013aa"
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
