class Cwalk < Formula
  desc "Cross-platform path library for C/C++"
  homepage "https://likle.github.io/cwalk/"
  url "https://github.com/likle/cwalk/archive/refs/tags/v1.2.9.tar.gz"
  sha256 "54f160031687ec90a414e0656cf6266445207cb91b720dacf7a7c415d6bc7108"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c6a86a42f343e1569e219befcd09e4e44eba308b2bb6afda312e0f0a14268492"
    sha256 cellar: :any,                 arm64_sequoia: "29c42c807b28bdddedc2e516d849158e1c8ead44add19f2ce91f45b9fc10e9af"
    sha256 cellar: :any,                 arm64_sonoma:  "d443cc393f71b65972a6fdbb471ebd0308a5988a8bc69bd6b65186540ef0c085"
    sha256 cellar: :any,                 sonoma:        "fcfad95bf683b8a14600cfbb41fde45ad5417af61a5517b760595b3057549698"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf8786364f7e8624b19576af4ce93bfd412d184bdb2ea22acb3b82df7f935e31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24d89dff54dc58a1f6f5a78a5a31d071d074138134ea765d7e185b6bb28ddea8"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=1", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOF
      #include <stdio.h>
      #include <cwalk.h>

      int main(int argc, char *argv[]) {
        const char *progname = NULL;
        cwk_path_get_basename(argv[0], &progname, NULL);
        printf("%s\\n", progname);
        return 0;
      }
    EOF

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcwalk", "-o", "test"
    assert_equal "test\n", shell_output("./test")
  end
end
