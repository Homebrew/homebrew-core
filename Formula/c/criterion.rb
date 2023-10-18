class Criterion < Formula
  desc "Cross-platform C and C++ unit testing framework for the 21st century"
  homepage "https://github.com/Snaipe/Criterion"
  url "https://github.com/Snaipe/Criterion/releases/download/v2.4.1/criterion-2.4.1.tar.xz"
  sha256 "d0f86a8fc868e2c7b83894ad058313023176d406501a4ee8863e5357e31a80e7"
  license "MIT"
  revision 3
  head "https://github.com/Snaipe/Criterion.git", branch: "bleeding"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "8c197f88d8ab0ef7db30d11c2621cf75b9c95a914b736a1a689351c7ba572ea2"
    sha256 cellar: :any, arm64_ventura:  "e2fa6b6131c59f39a3153bc8f5a90bcaf5c5ee4b7cf5375572c0e79edb559d81"
    sha256 cellar: :any, arm64_monterey: "6342d313467fc469437fedeff6dafcf6db55eb4e9afa56a4b3d39ed30ee3462c"
    sha256 cellar: :any, arm64_big_sur:  "a72de1d6b5e7dee339ff55d9e5322e31338997e0f750d1e90ba3879f1bd13ff9"
    sha256 cellar: :any, sonoma:         "331a9f46e37f20268a4f3397c1176fb81afc079b54c8f39b7f1d2d28445030db"
    sha256 cellar: :any, ventura:        "698a580f22b167eddca65ee4a296436ab78f414281cb6816bef1ba1112cb5ff2"
    sha256 cellar: :any, monterey:       "d047a288db8efb7335928601b3f33604a6784c6f0f134400bba0584e1d222e4d"
    sha256 cellar: :any, big_sur:        "b5552777b6e4a64ea00444da777d40d5c62078a77a1828e8610161143f36d5f4"
    sha256               x86_64_linux:   "b58276340d35a0ab8ed97152a6ed76d33547df5cac1bf69b8eaca673dc5fc6d6"
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
