class Klee < Formula
  desc "Symbolic Execution Engine"
  homepage "https://klee.github.io/"
  url "https://github.com/klee/klee/archive/v2.2.tar.gz"
  sha256 "1ff2e37ed3128e005b89920fad7bcf98c7792a11a589dd443186658f5eb91362"
  license "NCSA"
  revision 2
  head "https://github.com/klee/klee.git"

  bottle do
    sha256 big_sur:  "395c191dfd9034b29af9776a42f5a7371e174888e49dd1a67d8f07b7063f1500"
    sha256 catalina: "8876845fa423cc6ff77f4d24303d6fb718c44ad81b6403f006781edbfdaf72cf"
    sha256 mojave:   "18d715686c847555290fd2458df2e88a14f8ef33bcde0de2ed990cd54bb914ac"
  end

  depends_on "cmake" => :build
  depends_on "gperftools"
  depends_on "llvm"
  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "sqlite"
  depends_on "stp"
  depends_on "wllvm"
  depends_on "z3"

  uses_from_macos "zlib"

  # klee needs a version of libc++ compiled with wllvm
  resource "libcxx" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/llvm-project-12.0.0.src.tar.xz"
    sha256 "9ed1688943a4402d7c904cc4515798cdb20080066efa010fe7e1f2551b423628"
  end

  # Patches for LLVM 12 Support
  # https://github.com/klee/klee/pull/1389
  patch do
    url "https://github.com/klee/klee/commit/74ea9e5e63c5933ca2d5d7f846858c4de6e86b81.patch?full_index=1"
    sha256 "5af19fb3dbc609a180014f89a78bd007316e1384f3b23bf64fcd15621951b130"
  end

  patch do
    url "https://github.com/klee/klee/commit/a34fb8961649bf3a065ec8f0eb4bc58715fd1d57.patch?full_index=1"
    sha256 "beb18d3e74c8a580e2c3785e7224cacfb878b527fc4f261f7acb2ebecec93fb0"
  end

  patch do
    url "https://github.com/klee/klee/commit/2b29d86a39421ac76421b888b96613173bc18851.patch?full_index=1"
    sha256 "34515f7841dc3bc6e68888aa98492e3e003131fdc43018f4923799b0e2ff32fd"
  end

  patch do
    url "https://github.com/klee/klee/commit/c0b10c6f7a00d81cfce24115168dd06888685f87.patch?full_index=1"
    sha256 "d970235981e6f96f408b5943f80877b633a01cf098e1b4be2c19967b5412eff5"
  end

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
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
      libcxx_args << if OS.mac?
        "-DLIBCXX_ENABLE_STATIC_ABI_LIBRARY:BOOL=OFF"
      else
        "-DLIBCXX_ENABLE_STATIC_ABI_LIBRARY:BOOL=ON"
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
      -DKLEE_LIBCXX_DIR=#{libcxx_install_dir}
      -DKLEE_LIBCXX_INCLUDE_DIR=#{libcxx_install_dir}/include/c++/v1
      -DKLEE_LIBCXXABI_SRC_DIR=#{libcxx_src_dir}/libcxxabi
      -DLLVM_CONFIG_BINARY=#{llvm.opt_bin}/llvm-config
      -DENABLE_KLEE_ASSERTS=ON
      -DENABLE_KLEE_LIBCXX=ON
      -DENABLE_SOLVER_STP=ON
      -DENABLE_TCMALLOC=ON
      -DENABLE_SOLVER_Z3=ON
      -DENABLE_ZLIB=ON
      -DENABLE_DOCS=OFF
      -DENABLE_SYSTEM_TESTS=OFF
      -DENABLE_KLEE_EH_CXX=OFF
      -DENABLE_KLEE_UCLIBC=OFF
      -DENABLE_POSIX_RUNTIME=OFF
      -DENABLE_SOLVER_METASMT=OFF
      -DENABLE_UNIT_TESTS=OFF
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
