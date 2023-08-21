class Criterion < Formula
  desc "Cross-platform C and C++ unit testing framework for the 21st century"
  homepage "https://github.com/Snaipe/Criterion"
  url "https://github.com/Snaipe/Criterion/releases/download/v2.4.1/criterion-2.4.1.tar.xz"
  sha256 "d0f86a8fc868e2c7b83894ad058313023176d406501a4ee8863e5357e31a80e7"
  license "MIT"
  revision 2
  head "https://github.com/Snaipe/Criterion.git", branch: "bleeding"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "024f829292c95e44dcbf5d418dbab3f522de8b8817af94b9e6755922395cf10b"
    sha256 cellar: :any, arm64_monterey: "baaef6ed0a89f1dc2c23ab986b57bbe4c2b874bbf75e9ff4ecbbfe6a6fe4d3e6"
    sha256 cellar: :any, arm64_big_sur:  "ca48903b667e7a43848fa625c6a88faad8af1253b8439a1aa74859335fcc91f2"
    sha256 cellar: :any, ventura:        "46380b7b004712fa4989d35e0f6b9564474e509a612d5e386165ad2c7457f161"
    sha256 cellar: :any, monterey:       "0758af431a378629d15665b337af210dfb953f81d35daf38c81b532a0c6bdcc5"
    sha256 cellar: :any, big_sur:        "250273dc8dbe3d0b1517134e86c5d65fe6b223c93236a2e538b286d702f9ede9"
    sha256               x86_64_linux:   "4bd64030261a71a8aab068ca01edf2cdcdb9f5cbfe5dd5f63097123bed9706c5"
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
