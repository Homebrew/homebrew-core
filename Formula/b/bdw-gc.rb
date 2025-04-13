class BdwGc < Formula
  desc "Garbage collector for C and C++"
  homepage "https://www.hboehm.info/gc/"
  url "https://github.com/ivmai/bdwgc/releases/download/v8.2.8/gc-8.2.8.tar.gz"
  sha256 "7649020621cb26325e1fb5c8742590d92fb48ce5c259b502faf7d9fb5dabb160"
  license "MIT"
  head "https://github.com/ivmai/bdwgc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "58c2b5cf58c6ea30fc56a34aacfe36f774bed4cee1dca9808ef58d154a5ec965"
    sha256 cellar: :any,                 arm64_sonoma:   "26862c04a22c24bbbe25d7fd1a2fa4d499d5a7216101625115be645123ea0445"
    sha256 cellar: :any,                 arm64_ventura:  "55890248e3f2624e882660e38695e9090a8be1bff6c9a829ef35b0a30a890fee"
    sha256 cellar: :any,                 arm64_monterey: "013ffdfc107f8ec5d5382af87412bdfd4cb3503e866555fbe3252c3d7dcdcc10"
    sha256 cellar: :any,                 sonoma:         "54cd5df410fb01fc0f7a9b212b5ef40e8160e360e597b5d20e6e489df306ce37"
    sha256 cellar: :any,                 ventura:        "71c1beb334094059de83c81be4f1239e4ece22a1f7baf5c98d9682a2243b13bb"
    sha256 cellar: :any,                 monterey:       "33e2046794356d765327d03b638c8449e38a69055f801542ee4abd2ea6329f49"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "050c231beec4610f2d0a3c7bcc5cf8a7c7c6f93317fb8f990db26ba1c8950b66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f666fdf55ce3b41704f5869120ddfd3e973051d1fc0dc32a80733f20ba15ea0c"
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
    if OS.linux? || Hardware::CPU.arm? || MacOS.version > :monterey
      # Fails on 12-x86_64.
      system "ctest", "--test-dir", "build",
                      "--parallel", ENV.make_jobs,
                      "--rerun-failed",
                      "--output-on-failure"
    end
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
