class Klee < Formula
  desc "Symbolic Execution Engine"
  homepage "https://klee.github.io/"
  url "https://github.com/klee/klee/archive/v2.2.tar.gz"
  sha256 "1ff2e37ed3128e005b89920fad7bcf98c7792a11a589dd443186658f5eb91362"
  license "NCSA"
  revision 3
  head "https://github.com/klee/klee.git"

  bottle do
    sha256 big_sur:  "3534cffd757f8fa4c3be4f05c7534dbe705e54657512bb4a1b9d8b13cbe6b337"
    sha256 catalina: "508ab6444c02c26e061edf84519c18d888c4d9c1098c89215b5b788224838d37"
    sha256 mojave:   "b29dd739b4644aafc918f40a1c5abce7c00657c09a8959401c9ac8c77397a560"
  end

  depends_on "cmake" => :build
  depends_on "gperftools"
  depends_on "llvm@12"
  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "sqlite"
  depends_on "stp"
  depends_on "wllvm"
  depends_on "z3"

  uses_from_macos "zlib"

  # klee needs a version of libc++ compiled with wllvm
  resource "libcxx" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.1/llvm-project-12.0.1.src.tar.xz"
    sha256 "129cb25cd13677aad951ce5c2deb0fe4afc1e9d98950f53b51bdcfb5a73afa0e"
  end

  # Patches for LLVM 12 Support
  # https://github.com/klee/klee/pull/1389
  patch do
    url "https://github.com/klee/klee/commit/8ac323db7d367799fba9435b64fe715c603e60ba.patch?full_index=1"
    sha256 "e8c325ebe471b4f36eabd9d041f3ad9461061cc261c898e078d4dd211a1f3632"
  end

  patch do
    url "https://github.com/klee/klee/commit/96aa751760b4efc3424a82b573057008bc639c3b.patch?full_index=1"
    sha256 "1cbc17d413992f211f077687c4187f70b82d7129594fb178c7694fe1d897dac1"
  end

  patch do
    url "https://github.com/klee/klee/commit/3d7c05a7e86a72a4fc8df115591bd1e7a50f9d84.patch?full_index=1"
    sha256 "6eb99a36c25eaf311bcf666d4b893f9e9bdfd06b72cca63d570b6f3e8a8013bc"
  end

  patch do
    url "https://github.com/klee/klee/commit/8775b9cf6c716f51fe90d668e734a1288c8b5404.patch?full_index=1"
    sha256 "baefa3e332b2fb699d5329ba2e7c0d87485654dd7ae0a49e6da3a71102ef4ca0"
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
