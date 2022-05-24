class Criterion < Formula
  desc "Cross-platform C and C++ unit testing framework for the 21st century"
  homepage "https://github.com/Snaipe/Criterion"
  url "https://github.com/Snaipe/Criterion/releases/download/v2.4.1/criterion-2.4.1.tar.xz"
  sha256 "d0f86a8fc868e2c7b83894ad058313023176d406501a4ee8863e5357e31a80e7"
  license "MIT"
  head "https://github.com/Snaipe/Criterion.git", branch: "bleeding"

  bottle do
    sha256 cellar: :any, arm64_monterey: "5a284e7291b02f9b99c157baf3023e3a6bbc4ba904999b8b094f6f19db625f71"
    sha256 cellar: :any, arm64_big_sur:  "756811bab129f1d12072e184806f3d0c2d340ea88eeba2dba470d0e46a0c5cc0"
    sha256 cellar: :any, monterey:       "7f58f9eaeb7370f5ee50b871afa82dd6da248822b09495e602e551f7345cf7e2"
    sha256 cellar: :any, big_sur:        "c29c0ee229ff746bbe8b1ff0040376fce39d8ee0a359566ac2304d9b39759b3f"
    sha256 cellar: :any, catalina:       "2eaaa7be419c50953093f6ad8a9ee33eb22e820f245b1804e3c163a53420aaac"
    sha256               x86_64_linux:   "fb380b5c7cdb5d367b46807a8ca453a468ed262d1f054fb6824c45c9e8c5d8d5"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libgit2"
  depends_on "nanomsg"
  uses_from_macos "libffi"

  def install
    system "meson", "setup", *std_meson_args, "--force-fallback-for=boxfort", "build"
    system "meson", "compile", "-C", "build"
    system "meson", "install", "--skip-subprojects", "-C", "build"
  end

  test do
    (testpath/"test-criterion.c").write <<~EOS
      #include <criterion/criterion.h>

      Test(suite_name, test_name)
      {
        cr_assert(1);
      }
    EOS

    system ENV.cc, "test-criterion.c", "-I#{include}", "-L#{lib}", "-lcriterion", "-o", "test-criterion"
    system "./test-criterion"
  end
end
