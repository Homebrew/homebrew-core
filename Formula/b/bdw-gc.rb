class BdwGc < Formula
  desc "Garbage collector for C and C++"
  homepage "https://www.hboehm.info/gc/"
  url "https://github.com/bdwgc/bdwgc/releases/download/v8.2.12/gc-8.2.12.tar.gz"
  sha256 "42e5194ad06ab6ffb806c83eb99c03462b495d979cda782f3c72c08af833cd4e"
  license "MIT"
  head "https://github.com/bdwgc/bdwgc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "31d372ffb4bcce22e9871a81aeba2864f2233a9050b4f326deafdfbb31d21a58"
    sha256 cellar: :any,                 arm64_sequoia: "4946f5bffaceac9224502320f941350ab5301293e876d947d57926468b880941"
    sha256 cellar: :any,                 arm64_sonoma:  "353aac395e4812b85c6afcf7e22ae333bfa672737aff93dc68eef3a81feb4ebd"
    sha256 cellar: :any,                 sonoma:        "0bbf5a3924c6e7ffcdca91a2d3bd2569d918ae0c97ac7cc5caaa948dc881d106"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2db694f39b6f10d361221b3a8641152bac1a50624e120c4f4e8755efc3cdaef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd45675d8ded697e19ec009c1d6ad2848e6a28af0c2ff26cd41222f9627cd411"
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
