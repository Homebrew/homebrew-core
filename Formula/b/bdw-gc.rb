class BdwGc < Formula
  desc "Garbage collector for C and C++"
  homepage "https://www.hboehm.info/gc/"
  url "https://github.com/bdwgc/bdwgc/releases/download/v8.2.10/gc-8.2.10.tar.gz"
  sha256 "832cf4f7cf676b59582ed3b1bbd90a8d0e0ddbc3b11cb3b2096c5177ce39cc47"
  license "MIT"
  head "https://github.com/bdwgc/bdwgc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "254bb411834a430517fe915698e9390cb93f9e84b69e15474278aa8c4e955959"
    sha256 cellar: :any,                 arm64_sequoia: "fd7a11e13a54e13d44d7129ce59356b7ac814ac7d9484c565decbb4c9dd6686b"
    sha256 cellar: :any,                 arm64_sonoma:  "5b99cec3e7e5ac9fdc8444b1e9823cea3897f54d3008560d6055aa27b339590e"
    sha256 cellar: :any,                 sonoma:        "d2d6a52c5621a0e0aefe9dfbe08d50a9740c862db85671a7d501cfee410db5b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b72cc75c32c63a1aed7fe5c7c90657417d6953790dc9b78a9f05209bdbd2b75d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f57f9bbcb829ff506a5363883d5f6906d2ccc2043199c6138f186974035d6704"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -Denable_cplusplus=ON
      -Denable_large_config=ON
      -Dwithout_libatomic_ops=OFF
      -Dwith_libatomic_ops=OFF
    ]

    system "cmake", "-S", ".", "-B", "build",
                    "-Dbuild_tests=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args, *std_cmake_args,
                    "-DBUILD_TESTING=ON" # Pass this *after* `std_cmake_args`
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build",
                    "--parallel", ENV.make_jobs,
                    "--rerun-failed",
                    "--output-on-failure",
                    "--repeat", "until-pass:3"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install buildpath.glob("build-static/*.a")
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <stdio.h>
      #include "gc.h"

      int main(void)
      {
        int i;

        GC_INIT();
        for (i = 0; i < 10000000; ++i)
        {
          int **p = (int **) GC_MALLOC(sizeof(int *));
          int *q = (int *) GC_MALLOC_ATOMIC(sizeof(int));
          assert(*p == 0);
          *p = (int *) GC_REALLOC(q, 2 * sizeof(int));
        }
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lgc", "-o", "test"
    system "./test"
  end
end
