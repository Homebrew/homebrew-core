class Klee < Formula
  include Language::Python::Shebang

  desc "Symbolic Execution Engine"
  homepage "https://klee.github.io/"
  url "https://github.com/klee/klee/archive/v3.0.tar.gz"
  sha256 "204ebf0cb739886f574b1190b04fa9ed9088770c0634984782e9633d1aa4bdc9"
  license "NCSA"
  head "https://github.com/klee/klee.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "b5f061339b7061a9d44a038e09a9d71579af070590f216bd38a0d312bb34e00f"
    sha256 arm64_monterey: "75864bddc2c44e63bb721c69c461a694e9614448861bfff69c2ca3de8196a58e"
    sha256 arm64_big_sur:  "c2c7664241661c67dfadffe0eebb62bc1caea059215367f45c22e7fe20f3b95b"
    sha256 ventura:        "fb9816be6391e114836380c3550fe7518600d3eff2b16bfc69d1e7053e8060d4"
    sha256 monterey:       "8b578e55bb14346578ebfb852e4cf6dfdf3f717b941e16a0062a7204b46f91b5"
    sha256 big_sur:        "407ae407ca05e578ec4e13c3134b1e88f0b99a89af75a803746a99a3af768f70"
    sha256 x86_64_linux:   "06ceef2504cd321af3e2f428bd6e7098341608b53165d3d7ae2f0ab16c849e66"
  end

  depends_on "cmake" => :build
  depends_on "gperftools"
  depends_on "llvm@14"
  depends_on "python-tabulate"
  depends_on "python@3.11"
  depends_on "sqlite"
  depends_on "stp"
  depends_on "wllvm"
  depends_on "z3"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  # klee needs a version of libc++ compiled with wllvm
  resource "libcxx" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.6/llvm-project-14.0.6.src.tar.xz"
    sha256 "8b3cfd7bc695bd6cea0f37f53f0981f34f87496e79e2529874fd03a2f9dd3a8a"
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
      libcxx_args = std_cmake_args(install_prefix: libcxx_install_dir) + %w[
        -DCMAKE_C_COMPILER=wllvm
        -DCMAKE_CXX_COMPILER=wllvm++
        -DLLVM_ENABLE_PROJECTS=libcxx;libcxxabi
        -DLLVM_ENABLE_THREADS:BOOL=OFF
        -DLLVM_ENABLE_EH:BOOL=OFF
        -DLLVM_ENABLE_RTTI:BOOL=OFF
        -DLIBCXX_ENABLE_THREADS:BOOL=OFF
        -DLIBCXX_ENABLE_SHARED:BOOL=ON
        -DLIBCXXABI_ENABLE_THREADS:BOOL=OFF
      ]

      libcxx_args += if OS.mac?
        %W[
          -DCMAKE_INSTALL_RPATH=#{rpath}
          -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY:BOOL=OFF
        ]
      else
        %w[
          -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY:BOOL=ON
          -DCMAKE_CXX_FLAGS=-I/usr/include/x86_64-linux-gnu
        ]
      end

      mkdir "llvm/build" do
        with_env(
          LLVM_COMPILER:      "clang",
          LLVM_COMPILER_PATH: llvm.opt_bin,
        ) do
          system "cmake", "..", *libcxx_args
          system "make", "cxx"
          system "make", "-C", "projects", "install"

          Dir[libcxx_install_dir/"lib"/shared_library("*"), libcxx_install_dir/"lib/*.a"].each do |sl|
            next if File.symlink? sl

            system "extract-bc", sl
          end
        end
      end
    end

    # Homebrew-specific workaround to add paths to some glibc headers
    inreplace "runtime/CMakeLists.txt", "\"-I${CMAKE_SOURCE_DIR}/include\"",
      "\"-I${CMAKE_SOURCE_DIR}/include\"\n-I/usr/include/x86_64-linux-gnu"

    # Avoid building 32-bit runtime
    inreplace "CMakeLists.txt", "M32_SUPPORTED 1", "M32_SUPPORTED 0"

    # CMake options are documented at
    # https://github.com/klee/klee/blob/v#{version}/README-CMake.md
    args = %W[
      -DKLEE_RUNTIME_BUILD_TYPE=Release
      -DKLEE_LIBCXX_DIR=#{libcxx_install_dir}
      -DKLEE_LIBCXX_INCLUDE_DIR=#{libcxx_install_dir}/include/c++/v1
      -DKLEE_LIBCXXABI_SRC_DIR=#{libcxx_src_dir}/libcxxabi
      -DLLVM_CONFIG_BINARY=#{llvm.opt_bin}/llvm-config
      -DM32_SUPPORTED=OFF
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

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    rewrite_shebang detected_python_shebang, *bin.children
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
      KLEE: done: partially completed paths = 0
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
