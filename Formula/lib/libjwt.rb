class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://libjwt.io/"
  url "https://github.com/benmcollins/libjwt/archive/refs/tags/v3.3.2.tar.gz"
  sha256 "d1b16df8e7484d1856c21f770c6317cee3881c435a563160be76cf29d3142c8c"
  license "MPL-2.0"
  head "https://github.com/benmcollins/libjwt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b3c0e59441fd61310838be3bf56431278f62a40088bb2aa08e34aa367af07c2"
    sha256 cellar: :any,                 arm64_sequoia: "9d425b9d346a749652903b4200a72540177c973bc9e6464effc62444035d38d0"
    sha256 cellar: :any,                 arm64_sonoma:  "577c707c5d4555e57c08122a3ac9a06ef224263fd14260361d56c0a1943ea0e4"
    sha256 cellar: :any,                 sonoma:        "339ea2208717503a08ad98e08f65208bf9fb87f9be98a1413a9a490511a64d32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c914225e05eadba04a87bce03a0b47de2bf17164a868c82a13718838d2b2a3b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25e5ac26862c2ef56da81d43d666485124126a9164aa5188e449058709e5768b"
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
