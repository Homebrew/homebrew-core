class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://libjwt.io/"
  url "https://github.com/benmcollins/libjwt/releases/download/v3.2.2/libjwt-3.2.2.tar.xz"
  sha256 "a1813e1e0eebe4aad04f04137a4e80f2b17f79fd6c6211e36cf3a5854390cdfc"
  license "MPL-2.0"
  head "https://github.com/benmcollins/libjwt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9263b1b6a58dfba3cfe46b5552c9dcfc3a8018afba7152b114b651c269cd6376"
    sha256 cellar: :any,                 arm64_sequoia: "f66e83373617bf28770d2137147a54a48fd7e041b069f9d1062205d95edc1541"
    sha256 cellar: :any,                 arm64_sonoma:  "b6ec6f79fde651e82de34d13cb6a2dd773fa95409ebf96f6ca0f65c361aeb6dd"
    sha256 cellar: :any,                 arm64_ventura: "fc77250ccb9e904554f0b3cf9f6ce471af4ce7ede31c3ebc61220aba8b521422"
    sha256 cellar: :any,                 sonoma:        "3322bd76fc596750c2c8075cc65db4238645aef22f056afa26eb674a97632ba7"
    sha256 cellar: :any,                 ventura:       "9fa3aa9e69a64bf5de2c0145ad0234ca314726df918a937ad79ad158790cb9b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f698c50509e5088d09c378256ac2d89ebd784bfe8e0444c73fca3c5c792e9faa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9546a23e145bb4648828167e74746314b0fb9ca0fe179c7e5ea37dbccc984ae"
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
