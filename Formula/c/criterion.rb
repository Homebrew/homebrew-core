class Criterion < Formula
  desc "Cross-platform C and C++ unit testing framework for the 21st century"
  homepage "https://github.com/Snaipe/Criterion"
  url "https://github.com/Snaipe/Criterion/releases/download/v2.5.0/criterion-2.5.0.tar.xz"
  sha256 "740d5a9c00ca6f58f59dc20ba1ebecb3505d28287a8fe4ea3029c7f8a1906496"
  license "MIT"
  revision 1
  head "https://github.com/Snaipe/Criterion.git", branch: "bleeding"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ab6001c80380e5a71112354992f9bad277cc26869b6aee3a0138f59356ac7dda"
    sha256 cellar: :any, arm64_tahoe:       "6d7692b7bccedbd41434ef540d4612d08dbef0fb9113fd98da47f1826d1eb56a"
    sha256 cellar: :any, arm64_sequoia:     "b8467413f3e3ed2491d1af160ffca6b9d368e8f73678f6148c8de9f2a8677f9c"
    sha256 cellar: :any, arm64_linux:       "a3bb3c10344400a9ac431d94e9494ef21df2a978b52971574829df880b271654"
    sha256 cellar: :any, x86_64_linux:      "8b0ef5dc1012de37395c058e2aaf5f033be10d140e15e9dd1e5ce776fa19c903"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libgit2"
  depends_on "nanomsg"
  depends_on "nanopb"

  uses_from_macos "libffi"

  deny_network_access!

  def subprojects = %w[boxfort debugbreak klib]

  def fetch
    system "meson", "subprojects", "download", *subprojects if build.head?
  end

  def install
    system "meson", "setup", "build", "--force-fallback-for=#{subprojects.join(",")}", *std_meson_args
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
    # Running tests needs the runner's `/tmp` Unix socket, which the test sandbox denies, so only list them
    assert_match "suite_name: 1 test", shell_output("./test-criterion --list")
    assert_match version.to_s, shell_output("./test-criterion --version 2>&1")
  end
end
