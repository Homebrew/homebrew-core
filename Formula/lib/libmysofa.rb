class Libmysofa < Formula
  desc "Reader for AES SOFA files to get better HRTFs"
  homepage "https://github.com/hoene/libmysofa"
  url "https://github.com/hoene/libmysofa/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "f29508c335c83d8703f943ffc9ca783ac39aca84e851357f13a55af0f8143137"
  license "BSD-3-Clause"
  head "https://github.com/hoene/libmysofa.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "156aa6e7929414beec0649e6884e86d8d736ded3ed3b354e1ec49955a2a5e715"
    sha256 arm64_sequoia: "0dee5e7c17334fb428c02360a2a79c04ef8d1ae69309bda97db4349a1c7729ff"
    sha256 arm64_sonoma:  "cb2ed6152996738ae4776dde28a0471bf0196da65548ec07f6a0a04145ecf085"
    sha256 arm64_linux:   "15f3f4b330440fe4620dde5c4ce4ec60da6680457ec52e1df170509a1e33b9c6"
    sha256 x86_64_linux:  "419354e0b321624754fa2701ce8ef4bfdb0972fe2c2a84daaa78bd61450e878c"
  end

  depends_on "cmake" => :build
  depends_on "cunit" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <mysofa.h>

      int main(void)
      {
        int err;

        struct MYSOFA_HRTF *m = mysofa_load("#{share}/libmysofa/default.sofa", &err);
        if (!m) return 1;

        mysofa_free(m);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmysofa", "-o", "test"
    system "./test"
  end
end
