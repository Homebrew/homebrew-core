class Criterion < Formula
  desc "Cross-platform C and C++ unit testing framework for the 21st century"
  homepage "https://github.com/Snaipe/Criterion"
  url "https://github.com/Snaipe/Criterion/releases/download/v2.4.2/criterion-2.4.2.tar.xz"
  sha256 "e3c52fae0e90887aeefa1d45066b1fde64b82517d7750db7a0af9226ca6571c0"
  license "MIT"
  revision 2
  head "https://github.com/Snaipe/Criterion.git", branch: "bleeding"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "87e4b6050b97f8c93ffa634a013392a08dd9ca6ccde834ab0b38ef960bdbbb3c"
    sha256 cellar: :any, arm64_sonoma:  "cd2f6e03ef7b2bf9e3ba7e6620fc3f7971a98bba90ada27302ac84e1e0019ac4"
    sha256 cellar: :any, arm64_ventura: "c6f8a68eba64dd89f2a9748e37b7739919ef51f24c065495c1804b682bf507b5"
    sha256 cellar: :any, sonoma:        "85c669acf3f38a5a905425ece8bc92f8a845c9af1dcf569a4d9c18da99a4e507"
    sha256 cellar: :any, ventura:       "b43ee024021a2a0ae8ad6c1a246790b0990544cbe288d16bd6a21af517afab97"
    sha256               arm64_linux:   "eb14834df1db070905a92dce10ae4cc7602ad77a1ea6b47f4c2936c556ef0136"
    sha256               x86_64_linux:  "c0801143d8501a7af0e73b559b3af2d4877edf4cf2a9f5adb1f622915738f9e4"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libgit2"
  depends_on "nanomsg"
  depends_on "nanopb"

  uses_from_macos "libffi"

  def install
    system "meson", "setup", "build", "--force-fallback-for=boxfort,debugbreak,klib", *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "--skip-subprojects", "-C", "build"
  end

  test do
    (testpath/"test-criterion.c").write <<~C
      #include <criterion/criterion.h>

      Test(suite_name, test_name)
      {
        cr_assert(1);
      }
    C

    system ENV.cc, "test-criterion.c", "-I#{include}", "-L#{lib}", "-lcriterion", "-o", "test-criterion"
    system "./test-criterion"
  end
end
