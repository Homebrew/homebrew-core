class Criterion < Formula
  desc "Cross-platform C and C++ unit testing framework for the 21st century"
  homepage "https://github.com/Snaipe/Criterion"
  url "https://github.com/Snaipe/Criterion/releases/download/v2.4.3/criterion-2.4.3.tar.xz"
  sha256 "8ec64e482a70b3bfc1836ace0988b3316e6c3cfeac883fb5a674dcea5083ea16"
  license "MIT"
  head "https://github.com/Snaipe/Criterion.git", branch: "bleeding"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a9672d4007899f8d5441fafd3738863c93829abce3bc43031981c82b5c11f17c"
    sha256 cellar: :any, arm64_sequoia: "5d8ff893cb861d388519fd9fb8e01c4afab12bbce21842bc6292970fad1369f6"
    sha256 cellar: :any, arm64_sonoma:  "3f4b8ccceaf763235dc669387c0ee13af6cf4ef58b0f06403ba2fc54b172e796"
    sha256 cellar: :any, sonoma:        "262cc7f448b90131c51d7bf5bbc82d49707551f73fbfa53d7a0d917e077c80f3"
    sha256               arm64_linux:   "554c2d54bc12923dfe181c740f6a82af803485926fded8afa8daf3508239a341"
    sha256               x86_64_linux:  "6c9a32199fe0c88d3bfd6b9f4d40f17e573147152190cebb00fb72e58f287c16"
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
