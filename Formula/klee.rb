class Klee < Formula
  include Language::Python::Shebang

  desc "Symbolic Execution Engine"
  homepage "https://klee.github.io/"
  license "NCSA"
  revision 4
  head "https://github.com/klee/klee.git", branch: "master"

  stable do
    url "https://github.com/klee/klee/archive/v2.3.tar.gz"
    sha256 "6155fcaa4e86e7af8a73e8e4b63102abaea3a62d17e4021beeec47b0a3a6eff9"

    # Fix ARM build.
    # https://github.com/klee/klee/pull/1530
    patch do
      url "https://github.com/klee/klee/commit/885997a9841ab666ccf1f1b573b980aa8c84a339.patch?full_index=1"
      sha256 "6b070c676e002d455d7a4064c937b9b7c46eb576862cc85aba29dc7e6eecee91"
    end

    # Fix build with z3.
    patch do
      url "https://github.com/klee/klee/commit/39f8069db879e1f859c60c821092452748b4ba37.patch?full_index=1"
      sha256 "f03ddac150c320af8cefae33c958870cc649f1908e54c3309f1ae4791c4e84e1"
    end
  end

  bottle do
    sha256 arm64_ventura:  "a135fc9431d9e03c9cd0131c01360090986300754fffbe8baa7deb057afc124f"
    sha256 arm64_monterey: "ed674c12a9e2414e6152c48a73f4ef8c6d933f253e6ef4864295f4e9558fd75f"
    sha256 arm64_big_sur:  "2829efa164e390417595c73a70f8f3409f24a6bb181590091f46b6c3f115f760"
    sha256 ventura:        "f5f3ddc1c5edf4985ffd88b4c2f36c7239f7bff2c6114601803c8b2dc096293e"
    sha256 monterey:       "96bc452ac24d66be7a21ac8daca76cdbaefb2470ef6b4da354f0cfaeba44cdb6"
    sha256 big_sur:        "f9d4fd03f224dcbf15fde6e7dc96f3e36e3e10cb1eb0c384faae412af7d20c06"
    sha256 x86_64_linux:   "f1525a570a25ff4bb584c1bff4baaa83e11efc81da42901774ba958a5de68da0"
  end

  depends_on "cmake" => :build
  depends_on "gperftools"
  # LLVM 14 support in progress at https://github.com/klee/klee/pull/1477
  depends_on "llvm@13"
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
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.1/llvm-project-13.0.1.src.tar.xz"
    sha256 "326335a830f2e32d06d0a36393b5455d17dc73e0bd1211065227ee014f92cbf8"
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

    # CMake options are documented at
    # https://github.com/klee/klee/blob/v#{version}/README-CMake.md
    args = std_cmake_args + %W[
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

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

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
