class Klee < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Symbolic Execution Engine"
  homepage "https://klee-se.org"
  url "https://github.com/klee/klee/archive/refs/tags/v3.3.tar.gz"
  sha256 "baa73ad3d4bc345d28434c9aa54c639bfb504cd71c26852d1da1dd7cb22bfb48"
  license "NCSA"
  revision 1
  head "https://github.com/klee/klee.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "61aaf5d4d30fca9d10fbad3563890f5cedc65c5f8373920f0e80687f98b8ca5f"
    sha256 arm64_tahoe:       "289089d5a09bd037405ee3dcff07251839a72a8e8595169b745ab2608a34bd85"
    sha256 arm64_sequoia:     "4d4fefa40af9f27c92592f897b7dcbc41c97977fc9062653357c08e5d9a60d31"
    sha256 x86_64_linux:      "651476c37a969f617ef310d9929cf271245308782faec25be47e0af4daaece50"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "wllvm" => :build

  depends_on "gperftools"
  depends_on "llvm@19"
  depends_on "python@3.15"
  depends_on "sqlite"
  depends_on "stp"
  depends_on "z3"

  on_linux do
    # klee seems to stall when run on arm64. May not be supported yet:
    # * https://github.com/klee/klee/issues/1670
    # * https://github.com/klee/klee/issues/1767
    depends_on arch: :x86_64
    depends_on "zlib-ng-compat"
  end

  # klee needs a version of libc++ compiled with wllvm
  resource "libcxx" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.7/llvm-project-19.1.7.src.tar.xz"
    sha256 "82401fea7b79d0078043f7598b835284d6650a75b93e64b6f761ea7b63097501"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
    libcxx_install_dir = libexec/"libcxx"
    libcxx_src_dir = buildpath/"libcxx"
    resource("libcxx").stage libcxx_src_dir

    # Use build configuration at
    # https://github.com/klee/klee/blob/v#{version}/scripts/build/p-libcxx.inc
    libcxx_args = std_cmake_args(install_prefix: libcxx_install_dir) + %W[
      -DRUNTIMES_CMAKE_ARGS=-DCMAKE_INSTALL_RPATH=#{rpath}
      -DLLVM_ENABLE_RUNTIMES=libcxx;libcxxabi;libunwind
      -DLLVM_ENABLE_PROJECTS=
      -DLLVM_ENABLE_PROJECTS_USED:BOOL=ON
      -DLLVM_ENABLE_THREADS:BOOL=OFF
      -DLLVM_ENABLE_EH:BOOL=OFF
      -DLLVM_ENABLE_RTTI:BOOL=OFF
      -DLIBCXX_ENABLE_THREADS:BOOL=OFF
      -DLIBCXX_ENABLE_SHARED:BOOL=ON
      -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY:BOOL=#{OS.mac? ? "OFF" : "ON"}
      -DLIBCXXABI_ENABLE_THREADS:BOOL=OFF
      -DLIBCXXABI_USE_LLVM_UNWINDER:BOOL=ON
    ]

    with_env(
      CC:                 "wllvm",
      CXX:                "wllvm++",
      LLVM_COMPILER:      "clang",
      LLVM_COMPILER_PATH: llvm.opt_bin,
    ) do
      system "cmake", "-S", libcxx_src_dir/"llvm", "-B", "libcxx_build", *libcxx_args
      system "cmake", "--build", "libcxx_build", "--target", "runtimes"
      system "cmake", "--install", "libcxx_build/runtimes"
    end

    libcxx_libs = libcxx_install_dir.glob("lib/{#{shared_library("*")},*.a}").reject(&:symlink?)
    libcxx_libs.each { |sl| system "extract-bc", sl }

    # Avoid building 32-bit runtime
    inreplace "CMakeLists.txt", "M32_SUPPORTED 1", "M32_SUPPORTED 0"

    # CMake options are documented at
    # https://github.com/klee/klee/blob/v#{version}/README-CMake.md
    args = %W[
      -DKLEE_RUNTIME_BUILD_TYPE=Release
      -DKLEE_LIBCXX_DIR=#{libcxx_install_dir}
      -DKLEE_LIBCXX_BC_PATH=#{libcxx_install_dir}/lib
      -DKLEE_LIBCXX_INCLUDE_DIR=#{libcxx_install_dir}/include
      -DKLEE_LIBCXX_INCLUDE_PATH=#{libcxx_install_dir}/include/c++/v1
      -DKLEE_LIBCXXABI_SRC_DIR=#{libcxx_src_dir}/libcxxabi
      -DLLVM_CONFIG_BINARY=#{llvm.opt_bin}/llvm-config
      -DM32_SUPPORTED=OFF
      -DENABLE_KLEE_ASSERTS=OFF
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

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    venv = virtualenv_create(libexec/"venv", python3)
    venv.pip_install resource("tabulate")
    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), *bin.children
  end

  # Test adapted from
  # http://klee.github.io/tutorials/testing-function/
  test do
    (testpath/"get_sign.c").write <<~C
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
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, "-I#{opt_include}", "-emit-llvm",
                    "-c", "-g", "-O0", "-Xclang", "-disable-O0-optnone",
                    testpath/"get_sign.c"

    total_instructions = 30
    expected_output = <<~EOS
      KLEE: done: total instructions = #{total_instructions}
      KLEE: done: completed paths = 3
      KLEE: done: partially completed paths = 0
      KLEE: done: generated tests = 3
    EOS
    assert_match expected_output, shell_output("#{bin}/klee get_sign.bc 2>&1")
    assert_path_exists testpath/"klee-out-0"

    assert_match "['get_sign.bc']", shell_output("#{bin}/ktest-tool klee-last/test000001.ktest")

    system ENV.cc, "-I#{opt_include}", "-L#{opt_lib}", "-lkleeRuntest", testpath/"get_sign.c"
    with_env(KTEST_FILE: "klee-last/test000001.ktest") do
      system "./a.out"
    end

    assert_match <<~EOS, shell_output("#{bin}/klee-stats --print-columns='Instrs' --table-format=csv klee-out-0")
      Instrs
      #{total_instructions}
    EOS
  end
end
