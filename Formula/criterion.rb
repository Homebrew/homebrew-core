class Criterion < Formula
  desc "Cross-platform C and C++ unit testing framework for the 21st century"
  homepage "https://github.com/Snaipe/Criterion"
  url "https://github.com/Snaipe/Criterion/releases/download/v2.4.1/criterion-2.4.1.tar.xz"
  sha256 "d0f86a8fc868e2c7b83894ad058313023176d406501a4ee8863e5357e31a80e7"
  license "MIT"
  head "https://github.com/Snaipe/Criterion.git", branch: "bleeding"

  bottle do
    sha256 cellar: :any, arm64_monterey: "d9bb837fee2955cbf2e152c06a6ee25f9cbf0b5133c8743a211f4219b7f6356e"
    sha256 cellar: :any, arm64_big_sur:  "27bfdbe463b612044fdb4b1afe10c34cf64ad0c0ba3383c41195b92737c8bf94"
    sha256 cellar: :any, monterey:       "544ff0341824edbf20ce6af85aca2997227e4e5939dfb76ebd86271b84a99b39"
    sha256 cellar: :any, big_sur:        "bd9f064b13047f6565af43070e6a8f863c7cd345811c56c189987fb37bc0ab28"
    sha256 cellar: :any, catalina:       "b02c8f59bbf65e188810d78932638186db3496b6ab558b89c8d45c83dbb0d2be"
    sha256               x86_64_linux:   "264d2cd7d715301f1fc68567186aa08c3370603c0affeddfd79454f2eb62d228"
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
