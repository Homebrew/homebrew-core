class Criterion < Formula
  desc "Cross-platform C and C++ unit testing framework for the 21st century"
  homepage "https://github.com/Snaipe/Criterion"
  url "https://github.com/Snaipe/Criterion/releases/download/v2.4.2/criterion-2.4.2.tar.xz"
  sha256 "e3c52fae0e90887aeefa1d45066b1fde64b82517d7750db7a0af9226ca6571c0"
  license "MIT"
  head "https://github.com/Snaipe/Criterion.git", branch: "bleeding"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "dfcc1663c7ca47642db565c77773a3e68866cfc0d5d353629e20ef47649191d0"
    sha256 cellar: :any, arm64_ventura:  "5ae290e70fc07f3c78d8827027b70232c87ff07bb7297161bde71c9792fb407c"
    sha256 cellar: :any, arm64_monterey: "f8e3b622a0cd0dbcb169d7595cd15acbe81cc666fb3344f0f0a560fd5740afbf"
    sha256 cellar: :any, sonoma:         "ec1932cc75323624c4d43a5eb3d54b02b3ec0d016cb111695488b681eb67874e"
    sha256 cellar: :any, ventura:        "3e7ad78fdf43eddaa64dce5caf15fc28806e8066adc8625720a7bfa2fc9fe795"
    sha256 cellar: :any, monterey:       "4a591b4b9f37f8343dc5900ad42b8daff1703fa9b7e03b5957b2b94476ea8d89"
    sha256               x86_64_linux:   "cbb32a2c8d32f1c0611d3194c03190bd9f61bcfd6c6052d03fcf9d5f201139c9"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libgit2"
  depends_on "nanomsg"
  depends_on "nanopb"

  uses_from_macos "libffi"

  def install
    system "meson", "setup", *std_meson_args, "--force-fallback-for=boxfort,debugbreak,klib", "build"
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
