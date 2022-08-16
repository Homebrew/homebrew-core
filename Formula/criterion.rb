class Criterion < Formula
  desc "Cross-platform C and C++ unit testing framework for the 21st century"
  homepage "https://github.com/Snaipe/Criterion"
  url "https://github.com/Snaipe/Criterion/releases/download/v2.4.1/criterion-2.4.1.tar.xz"
  sha256 "d0f86a8fc868e2c7b83894ad058313023176d406501a4ee8863e5357e31a80e7"
  license "MIT"
  revision 1
  head "https://github.com/Snaipe/Criterion.git", branch: "bleeding"

  bottle do
    sha256 cellar: :any, arm64_monterey: "936db451f3b333687d75ee02f987793b5a2a6e799bdf19d4c402f4942a6466bb"
    sha256 cellar: :any, arm64_big_sur:  "893ed763895b094bfdcfaae2891fcb9c07c308d1d207da5aa988340a6d41f56b"
    sha256 cellar: :any, monterey:       "ccea6bdbe908966b8152948d39672bbe475a85dfa2d34e702a02ab17df236358"
    sha256 cellar: :any, big_sur:        "d6f833935149e7b6a85b2735db748251c076cdc3e4fb4ad9268ca26df0392d51"
    sha256 cellar: :any, catalina:       "5abf4ef75d576ccdfdd7d482cd74e9a97b82f86aef95c8aa731722da87bc93d0"
    sha256               x86_64_linux:   "6953412c2e5eb4676c7c3f8a46faf5329455f3416a076a23a71d4fdc163a72cc"
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
