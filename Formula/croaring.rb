class Croaring < Formula
  desc "Roaring bitmaps in C (and C++)"
  homepage "https://roaringbitmap.org"
  url "https://github.com/RoaringBitmap/CRoaring/archive/v0.8.0.tar.gz"
  sha256 "cd6c4770baccfea385c0c6891a8a80133ba26093209740ca0a3eea348aff1a20"
  license "Apache-2.0"
  head "https://github.com/RoaringBitmap/CRoaring.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfa53698ab021d3f6f4b6435daaa608094bb2945a4c7f412065065c164810a48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b59b01ab9dadeed19321ebea91389ed228e4db2f7cd6aeca12eee58c4e51b8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b542a7fbf688538547f31fa9d2a94b496552924cb9aa8f6dbc72efe6856b09e9"
    sha256 cellar: :any_skip_relocation, monterey:       "bd204ea967617d9c3ef08ac6f86f19a0017c4296b3b0a54c9b1c54e1018a7f88"
    sha256 cellar: :any_skip_relocation, big_sur:        "3598e943f08ffce1247088fc79dc4c2d127efd61c3398e62dc5d10101a1fa545"
    sha256 cellar: :any_skip_relocation, catalina:       "cb28c348e3314d458e7d56adb1533b270349cf758ed02541db121e4192bb2de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ae1b7f62b2315d58b2e7f5d42ff168dbce2eec7d7b648add6213e6fba4a6331"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args, "-DENABLE_ROARING_TESTS=OFF"
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", *std_cmake_args, "-DROARING_BUILD_STATIC=ON"
    system "make"
    lib.install "src/libroaring.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <roaring/roaring.h>
      int main() {
          roaring_bitmap_t *r1 = roaring_bitmap_create();
          for (uint32_t i = 100; i < 1000; i++) roaring_bitmap_add(r1, i);
          printf("cardinality = %d\\n", (int) roaring_bitmap_get_cardinality(r1));
          roaring_bitmap_free(r1);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lroaring", "-o", "test"
    assert_equal "cardinality = 900\n", shell_output("./test")
  end
end
