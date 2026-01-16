class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://libjwt.io/"
  url "https://github.com/benmcollins/libjwt/releases/download/v3.2.3/libjwt-3.2.3.tar.xz"
  sha256 "c6d8a4ead0321317937cc29d8ebc5be48d114d02e007711bb2d4cca5d2a6d713"
  license "MPL-2.0"
  head "https://github.com/benmcollins/libjwt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e2e50cc16694fb18716b0d2c2252690684f34e9407448beddb77c3718940f026"
    sha256 cellar: :any,                 arm64_sequoia: "4f884d59b53c182433bccdccae89453a3263ff2960adb684515bfa8cca6cac1f"
    sha256 cellar: :any,                 arm64_sonoma:  "7be05fb863675b92132528d6ec3b56877f40ecacdd19bda09528efb3dec56446"
    sha256 cellar: :any,                 sonoma:        "2d022ed797aa77a6249858492353805eb38f80b9d6b67c40e2c76a4d31af2eca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b766edf05dd96d12a0ae8bca1b05ecb9dd04d42219a61a4792344a48e6411a2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc17d3bf1028fa82a710ae0d68e2cdbecf9fb078dd880421886525735a0dfe73"
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
