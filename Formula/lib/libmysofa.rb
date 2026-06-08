class Libmysofa < Formula
  desc "Reader for AES SOFA files to get better HRTFs"
  homepage "https://github.com/hoene/libmysofa"
  url "https://github.com/hoene/libmysofa/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "64c661f75ef39edf68bfc3a28403d2b5a0bd251d0b9f5d021ed6f7917867fb37"
  license "BSD-3-Clause"
  head "https://github.com/hoene/libmysofa.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "cunit" => :build
  depends_on "nodejs"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    cd "build" do
      system "cmake", "-S", "..", *std_cmake_args
      system "make", "all"
      system "cmake", "--install", "."
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <mysofa.h>
      
      int main(void)
      {
        struct mysofa *m = mysofa_load("#{share}/libmysofa/sofa/IRC_1002_C_HRIR.sofa");
        if (!m) return 1;
        mysofa_free(m);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmysofa", "-o", "test"
    system "./test"
  end
end
