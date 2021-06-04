class Klee < Formula
  desc "Symbolic Execution Engine"
  homepage "https://klee.github.io/"
  url "https://github.com/klee/klee/archive/v2.2.tar.gz"
  sha256 "1ff2e37ed3128e005b89920fad7bcf98c7792a11a589dd443186658f5eb91362"
  license "NCSA"
  revision 1
  head "https://github.com/klee/klee.git"

  bottle do
    sha256 big_sur:  "68926d21ba91e49e600c58329c81ffbe552ceac655b9c57ae6043e0df4ca926a"
    sha256 catalina: "d601b6ef40172702659f7efe267d766fe1c82a627afed9017467c4714e3aac52"
    sha256 mojave:   "30147bcef9d3993cb28f0e4235d0e0cb061b1f03dbfd6d698d7fd3ab214dc712"
  end

  depends_on "cmake" => :build
  depends_on "gperftools"
  depends_on "llvm@11"
  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "sqlite"
  depends_on "wllvm"
  depends_on "z3"

  uses_from_macos "zlib"

  # klee needs a version of libc++ compiled with wllvm
  resource "libcxx" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.1.0/llvm-project-11.1.0.src.tar.xz"
    sha256 "74d2529159fd118c3eac6f90107b5611bccc6f647fdea104024183e8d5e25831"
  end

  def install
    llvm = Formula["llvm@11"]

    libcxx_install_dir = libexec/"libcxx"
    libcxx_src_dir = buildpath/"libcxx"
    resource("libcxx").stage libcxx_src_dir

    cd libcxx_src_dir do
      # Use build configuration at
      # https://github.com/klee/klee/blob/v#{version}/scripts/build/p-libcxx.inc
      libcxx_args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
        -DCMAKE_C_COMPILER=wllvm
        -DCMAKE_CXX_COMPILER=wllvm++
        -DCMAKE_INSTALL_PREFIX=#{libcxx_install_dir}
        -DLLVM_ENABLE_PROJECTS=libcxx;libcxxabi
        -DLLVM_ENABLE_THREADS:BOOL=OFF
        -DLLVM_ENABLE_EH:BOOL=OFF
        -DLLVM_ENABLE_RTTI:BOOL=OFF
        -DLIBCXX_ENABLE_THREADS:BOOL=OFF
        -DLIBCXX_ENABLE_SHARED:BOOL=ON
        -DLIBCXXABI_ENABLE_THREADS:BOOL=OFF
      ]
      on_macos do
        libcxx_args << "-DLIBCXX_ENABLE_STATIC_ABI_LIBRARY:BOOL=OFF"
      end
      on_linux do
        libcxx_args << "-DLIBCXX_ENABLE_STATIC_ABI_LIBRARY:BOOL=ON"
      end

      mkdir "llvm/build" do
        with_env(
          LLVM_COMPILER:      "clang",
          LLVM_COMPILER_PATH: llvm.opt_bin,
        ) do
          system "cmake", "..", *libcxx_args
          system "make", "cxx"
          system "make", "-C", "projects", "install"

          Dir[libcxx_install_dir/"lib/#{shared_library("*")}", libcxx_install_dir/"lib/*.a"].each do |sl|
            next if File.symlink? sl

            system "extract-bc", sl
          end
        end
      end
    end

    # CMake options are documented at
    # https://github.com/klee/klee/blob/v#{version}/README-CMake.md
    args = std_cmake_args + %W[
      -DKLEE_RUNTIME_BUILD_TYPE=Release
      -DLLVM_CONFIG_BINARY=#{llvm.opt_bin}/llvm-config
      -DENABLE_DOCS=OFF
      -DENABLE_SYSTEM_TESTS=OFF
      -DENABLE_KLEE_ASSERTS=ON
      -DENABLE_KLEE_LIBCXX=ON
      -DENABLE_KLEE_EH_CXX=OFF
      -DENABLE_KLEE_UCLIBC=OFF
      -DENABLE_POSIX_RUNTIME=OFF
      -DENABLE_SOLVER_METASMT=OFF
      -DENABLE_SOLVER_STP=OFF
      -DENABLE_UNIT_TESTS=OFF
      -DENABLE_TCMALLOC=ON
      -DENABLE_SOLVER_Z3=ON
      -DENABLE_ZLIB=ON
      -DKLEE_LIBCXX_DIR=#{libcxx_install_dir}
      -DKLEE_LIBCXX_INCLUDE_DIR=#{libcxx_install_dir}/include/c++/v1
      -DKLEE_LIBCXXABI_SRC_DIR=#{libcxx_src_dir}/libcxxabi
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  # Test adapted from
  # http://klee.github.io/tutorials/testing-function/
  test do
    llvm = Formula["llvm@11"]

    (testpath/"get_sign.c").write <<~EOS
      #include "klee/klee.h"

      int get_sign(int x) {
        if (x == 0)
          return 0;
        if (x < 0)
          return -1;
        else
          return 1;
      }

      int main() {
        int a;
        klee_make_symbolic(&a, sizeof(a), "a");
        return get_sign(a);
      }
    EOS

    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, "-I#{opt_include}", "-emit-llvm",
                    "-c", "-g", "-O0", "-disable-O0-optnone",
                    testpath/"get_sign.c"

    expected_output = <<~EOS
      KLEE: done: total instructions = 33
      KLEE: done: completed paths = 3
      KLEE: done: generated tests = 3
    EOS
    output = pipe_output("#{bin}/klee get_sign.bc 2>&1")
    assert_match expected_output, output
    assert_predicate testpath/"klee-out-0", :exist?

    assert_match "['get_sign.bc']", shell_output("#{bin}/ktest-tool klee-last/test000001.ktest")

    system ENV.cc, "-I#{opt_include}", "-L#{opt_lib}", "-lkleeRuntest", testpath/"get_sign.c"
    with_env(KTEST_FILE: "klee-last/test000001.ktest") do
      system "./a.out"
    end
  end
end
