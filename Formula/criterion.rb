class Criterion < Formula
  desc "Cross-platform C and C++ unit testing framework for the 21st century"
  homepage "https://github.com/Snaipe/Criterion"
  url "https://github.com/Snaipe/Criterion/releases/download/v2.4.0/criterion-2.4.0.tar.xz"
  sha256 "b13bdb9e007d4d2e87a13446210630e95e3e3d92bb731951bcea4993464b9911"
  license "MIT"
  revision 1
  head "https://github.com/Snaipe/Criterion.git", branch: "bleeding"

  bottle do
    sha256 cellar: :any, arm64_monterey: "0023dd52165f159b3714626e60a968b2fae23aa4252136a9719a1f008038fafd"
    sha256 cellar: :any, arm64_big_sur:  "ad565bdd7ddeace8056dbb89fbc278c9af1864a6a8c4573ac56bcd5a466cada0"
    sha256 cellar: :any, monterey:       "4540263d2c6013dd60143e7f0f5b0c090b20ddf760bdf027c07b8478dd90c69f"
    sha256 cellar: :any, big_sur:        "5e2cd7bcf2ae4cab91c4b2c9669d48d295e3bfa3f32ef101eb0fc4a4c5f9efe3"
    sha256 cellar: :any, catalina:       "2bd7d304278a9593d08bba3849ab157b248a7e901efa86e56bd1169773f4ccd5"
    sha256               x86_64_linux:   "e39a40f48b213e37f0270174ca0836e22459df5c95567de9f498eafa79869534"
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
