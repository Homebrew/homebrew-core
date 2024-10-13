class Criterion < Formula
  desc "Cross-platform C and C++ unit testing framework for the 21st century"
  homepage "https://github.com/Snaipe/Criterion"
  url "https://github.com/Snaipe/Criterion/releases/download/v2.4.2/criterion-2.4.2.tar.xz"
  sha256 "e3c52fae0e90887aeefa1d45066b1fde64b82517d7750db7a0af9226ca6571c0"
  license "MIT"
  revision 1
  head "https://github.com/Snaipe/Criterion.git", branch: "bleeding"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "a880153b64b65008d1d92ed11ba5a67261d82b255a8dafbd9921ecba80e9ebc7"
    sha256 cellar: :any, arm64_sonoma:   "575118c0a83351e49c5f6504d80e7022186e7f7b21da529ad3015969d9c46f0a"
    sha256 cellar: :any, arm64_ventura:  "6b9c4a49f635a0eac301d1ed822fd38d5912a2e9a871e814b3ecba2ac58d6e11"
    sha256 cellar: :any, arm64_monterey: "59ab15a4aed2eaa77fb3b98db32814872866cafba2b9b52a9f1bf7bb0efa6c0c"
    sha256 cellar: :any, sonoma:         "8a1fe522970384b9a8711295d3c9903258da51247118b4b690cbba3392d9ba60"
    sha256 cellar: :any, ventura:        "40f455121c1d6d57adf4219972db267a0771a382545ba1446c7cbff6ed2344b5"
    sha256 cellar: :any, monterey:       "b3a62482e751294a5721e415f743cef1e4ccb86770abb5a06645d49089f76501"
    sha256               x86_64_linux:   "498652568251bf981b761f3180eaa9c31ddd66cd74604678b3e603f3818e9b91"
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
