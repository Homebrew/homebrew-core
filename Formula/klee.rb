class Klee < Formula
  include Language::Python::Shebang

  desc "Symbolic Execution Engine"
  homepage "https://klee.github.io/"
  license "NCSA"
  revision 2
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
    sha256 arm64_monterey: "cf1718555f9744ab53f293303d0ed62338b289b9db8c759f6c25be7111943c6b"
    sha256 arm64_big_sur:  "187c1c111ea8277c9f7a6eb56c65a16bf7b87ce0525716a8c6cab01baf26826e"
    sha256 monterey:       "61d2886cefc32cb502774c8676b4584b5766b01154d7ecc52d5d85174d8bb8a0"
    sha256 big_sur:        "a8180392d6904683027f527b054337e16b669e26f6a87e7edb451dffb2f864b1"
    sha256 catalina:       "383d0adece071c7ddb002ea1a00aaeef99a88a9f17d7a064a0bc863682fecb60"
    sha256 x86_64_linux:   "6ea46cbe3b4bac2fa595729e86a9cc9f054c873f22d19b86f467cb0e5784bf7f"
  end

  depends_on "cmake" => :build
  depends_on "gperftools"
  depends_on "libpython-tabulate"
  # LLVM 14 support in progress at https://github.com/klee/klee/pull/1477
  depends_on "llvm@13"
  depends_on "python@3.10"
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
