class LlvmAT9 < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/llvm-9.0.1.src.tar.xz"
  sha256 "00a1ee1f389f81e9979f3a640a01c431b3021de0d42278f6508391a2f0b81c9a"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  revision 4

  bottle do
    sha256 cellar: :any,                 monterey:     "f7d35848ad1b76f358c742719cf3f0fe5cc913a0e04e1a81838ecc30cea22d7f"
    sha256 cellar: :any,                 big_sur:      "611f1a48eaa5ea4abda72ec633671c1ec56541fb2acf9ed8021ac540e863ab33"
    sha256 cellar: :any,                 catalina:     "111e5fdea2179635cb834f62ac0e8e967c4b9e9ad4ed99c8db6a0879f58ff524"
    sha256 cellar: :any,                 mojave:       "de79caa57933b7618c0cb92aad49fdf7f8758d0875466050908737d32f9e5b61"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "02addeab63f5540124b9b12c600952190c400c3a7559596537166ef21d9cf3d9"
  end

  # Clang cannot find system headers if Xcode CLT is not installed
  pour_bottle? only_if: :clt_installed

  keg_only :versioned_formula

  # https://llvm.org/docs/GettingStarted.html#requirement
  depends_on "cmake" => :build
  depends_on arch: :x86_64
  depends_on "swig"

  uses_from_macos "libedit"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "glibc" if Formula["glibc"].any_version_installed?
    depends_on "binutils" # needed for gold and strip
    depends_on "elfutils" # openmp requires <gelf.h>
    depends_on "python@3.8"
  end

  resource "clang" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/clang-9.0.1.src.tar.xz"
    sha256 "5778512b2e065c204010f88777d44b95250671103e434f9dc7363ab2e3804253"

    # Fix for Big Sur+ SDK. Backported from
    # https://github.com/llvm/llvm-project/commit/a3a24316087d0e1b4db0b8fee19cdee8b7968032
    patch :p3 do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/1f6960faf59a8d3d83ba8c32d0ec389febfee792/llvm%409/llvm%409.patch"
      sha256 "02fb21c26f468b0dab25c93b2802539133e06b0bcf19802a7ecdc227c454c4db"
    end
  end

  resource "clang-extra-tools" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/clang-tools-extra-9.0.1.src.tar.xz"
    sha256 "b26fd72a78bd7db998a26270ec9ec6a01346651d88fa87b4b323e13049fb6f07"
  end

  resource "compiler-rt" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/compiler-rt-9.0.1.src.tar.xz"
    sha256 "c2bfab95c9986318318363d7f371a85a95e333bc0b34fbfa52edbd3f5e3a9077"
  end

  resource "libcxx" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/libcxx-9.0.1.src.tar.xz"
    sha256 "0981ff11b862f4f179a13576ab0a2f5530f46bd3b6b4a90f568ccc6a62914b34"
  end

  resource "libunwind" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/libunwind-9.0.1.src.tar.xz"
    sha256 "535a106a700889274cc7b2f610b2dcb8fc4b0ea597c3208602d7d037141460f1"
  end

  resource "lld" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/lld-9.0.1.src.tar.xz"
    sha256 "86262bad3e2fd784ba8c5e2158d7aa36f12b85f2515e95bc81d65d75bb9b0c82"
  end

  resource "lldb" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/lldb-9.0.1.src.tar.xz"
    sha256 "8a7b9fd795c31a3e3cba6ce1377a2ae5c67376d92888702ce27e26f0971beb09"
  end

  resource "openmp" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/openmp-9.0.1.src.tar.xz"
    sha256 "5c94060f846f965698574d9ce22975c0e9f04c9b14088c3af5f03870af75cace"
  end

  resource "polly" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/polly-9.0.1.src.tar.xz"
    sha256 "9a4ac69df923230d13eb6cd0d03f605499f6a854b1dc96a9b72c4eb075040fcf"
  end

  resource "libcxxabi" do
    on_linux do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/libcxxabi-9.0.1.src.tar.xz"
      sha256 "e8f978aa4cfae2d7a0b4d89275637078557cca74b35c31b7283d4786948a8aac"
    end
  end

  def install
    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    (buildpath/"tools/clang").install resource("clang")
    (buildpath/"tools/clang/tools/extra").install resource("clang-extra-tools")
    (buildpath/"projects/openmp").install resource("openmp")
    (buildpath/"projects/libcxx").install resource("libcxx")
    (buildpath/"projects/libcxxabi").install resource("libcxxabi") if OS.linux?
    (buildpath/"projects/libunwind").install resource("libunwind")
    (buildpath/"tools/lld").install resource("lld")
    (buildpath/"tools/lldb").install resource("lldb")
    (buildpath/"tools/polly").install resource("polly")
    (buildpath/"projects/compiler-rt").install resource("compiler-rt")

    # compiler-rt has some iOS simulator features that require i386 symbols
    # I'm assuming the rest of clang needs support too for 32-bit compilation
    # to work correctly, but if not, perhaps universal binaries could be
    # limited to compiler-rt. llvm makes this somewhat easier because compiler-rt
    # can almost be treated as an entirely different build from llvm.
    ENV.permit_arch_flags

    args = %w[
      -DLIBOMP_ARCH=x86_64
      -DLINK_POLLY_INTO_TOOLS=ON
      -DLLVM_BUILD_LLVM_DYLIB=ON
      -DLLVM_ENABLE_EH=ON
      -DLLVM_ENABLE_FFI=ON
      -DLLVM_ENABLE_RTTI=ON
      -DLLVM_ENABLE_Z3_SOLVER=OFF
      -DLLVM_INCLUDE_DOCS=OFF
      -DLLVM_INSTALL_UTILS=ON
      -DLLVM_OPTIMIZED_TABLEGEN=ON
      -DLLVM_TARGETS_TO_BUILD=all
      -DWITH_POLLY=ON
      -DLLDB_USE_SYSTEM_DEBUGSERVER=ON
      -DLLDB_DISABLE_PYTHON=1
      -DLIBOMP_INSTALL_ALIASES=OFF
    ]

    if MacOS.version >= :catalina
      args << "-DFFI_INCLUDE_DIR=#{MacOS.sdk_path}/usr/include/ffi"
      args << "-DFFI_LIBRARY_DIR=#{MacOS.sdk_path}/usr/lib"
    else
      args << "-DFFI_INCLUDE_DIR=#{Formula["libffi"].opt_include}"
      args << "-DFFI_LIBRARY_DIR=#{Formula["libffi"].opt_lib}"
    end

    if OS.mac?
      args << "-DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON" if MacOS.version <= :mojave
      args << "-DLLVM_CREATE_XCODE_TOOLCHAIN=ON"
      args << "-DLLVM_ENABLE_LIBCXX=ON"
      args << "-DDARWIN_osx_ARCHS=x86_64;x86_64h"

      sdk = MacOS.sdk_path_if_needed
      args << "-DDEFAULT_SYSROOT=#{sdk}" if sdk
    end

    if OS.linux?
      args << "-DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON"
      args << "-DLLVM_CREATE_XCODE_TOOLCHAIN=OFF"
      args << "-DLLVM_ENABLE_LIBCXX=OFF"
      args << "-DCLANG_DEFAULT_CXX_STDLIB=libstdc++"

      # Enable llvm gold plugin for LTO
      args << "-DLLVM_BINUTILS_INCDIR=#{Formula["binutils"].opt_include}"

      args += %w[
        -DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR=OFF
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON

        -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON
        -DLIBCXX_STATICALLY_LINK_ABI_IN_SHARED_LIBRARY=OFF
        -DLIBCXX_STATICALLY_LINK_ABI_IN_STATIC_LIBRARY=ON
        -DLIBCXX_USE_COMPILER_RT=ON

        -DLIBCXXABI_ENABLE_STATIC_UNWINDER=ON
        -DLIBCXXABI_STATICALLY_LINK_UNWINDER_IN_SHARED_LIBRARY=OFF
        -DLIBCXXABI_STATICALLY_LINK_UNWINDER_IN_STATIC_LIBRARY=ON
        -DLIBCXXABI_USE_COMPILER_RT=ON
        -DLIBCXXABI_USE_LLVM_UNWINDER=ON

        -DLIBUNWIND_USE_COMPILER_RT=ON
      ]
    end

    mkdir "build" do
      system "cmake", "-G", "Unix Makefiles", "..", *(std_cmake_args + args)
      system "make"
      system "make", "install"
      system "make", "install-xcode-toolchain" if MacOS::Xcode.installed?
    end

    (share/"clang/tools").install Dir["tools/clang/tools/scan-{build,view}"]
    (share/"cmake").install "cmake/modules"
    inreplace "#{share}/clang/tools/scan-build/bin/scan-build", "$RealBin/bin/clang", "#{bin}/clang".gsub("@", "\\@")
    bin.install_symlink share/"clang/tools/scan-build/bin/scan-build", share/"clang/tools/scan-view/bin/scan-view"
    man1.install_symlink share/"clang/tools/scan-build/man/scan-build.1"

    # install llvm python bindings
    xz = if OS.mac?
      "2.7"
    else
      "3.8"
    end
    (lib/"python#{xz}/site-packages").install buildpath/"bindings/python/llvm"
    (lib/"python#{xz}/site-packages").install buildpath/"tools/clang/bindings/python/clang"

    # install emacs modes
    elisp.install Dir["utils/emacs/*.el"] + %w[
      tools/clang/tools/clang-format/clang-format.el
      tools/clang/tools/clang-rename/clang-rename.el
      tools/clang/tools/extra/clang-include-fixer/tool/clang-include-fixer.el
    ]
  end

  def caveats
    <<~EOS
      To use the bundled libc++ please add the following LDFLAGS:
        LDFLAGS="-L#{opt_lib} -Wl,-rpath,#{opt_lib}"
    EOS
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/llvm-config --prefix").chomp

    (testpath/"omptest.c").write <<~EOS
      #include <stdlib.h>
      #include <stdio.h>
      #include <omp.h>
      int main() {
          #pragma omp parallel num_threads(4)
          {
            printf("Hello from thread %d, nthreads %d\\n", omp_get_thread_num(), omp_get_num_threads());
          }
          return EXIT_SUCCESS;
      }
    EOS

    clean_version = version.to_s[/(\d+\.?)+/]

    args = [
      "-L#{lib}",
      "-fopenmp",
      "-nobuiltininc",
      "-I#{lib}/clang/#{clean_version}/include",
    ]
    args << "-Wl,-rpath=#{lib}" if OS.linux?

    system "#{bin}/clang", *args, "omptest.c", "-o", "omptest", *ENV["LDFLAGS"].split
    testresult = shell_output("./omptest")

    sorted_testresult = testresult.split("\n").sort.join("\n")
    expected_result = <<~EOS
      Hello from thread 0, nthreads 4
      Hello from thread 1, nthreads 4
      Hello from thread 2, nthreads 4
      Hello from thread 3, nthreads 4
    EOS
    assert_equal expected_result.strip, sorted_testresult.strip

    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        printf("Hello World!\\n");
        return 0;
      }
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      int main()
      {
        std::cout << "Hello World!" << std::endl;
        return 0;
      }
    EOS

    # Testing default toolchain and SDK location.
    system "#{bin}/clang++", "-v",
           "-std=c++11", "test.cpp", "-o", "test++"
    assert_includes MachO::Tools.dylibs("test++"), "/usr/lib/libc++.1.dylib" if OS.mac?
    assert_equal "Hello World!", shell_output("./test++").chomp
    system "#{bin}/clang", "-v", "test.c", "-o", "test"
    assert_equal "Hello World!", shell_output("./test").chomp

    # Testing Command Line Tools
    if MacOS::CLT.installed?
      toolchain_path = "/Library/Developer/CommandLineTools"
      sdk_path = "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk"
      system "#{bin}/clang++", "-v",
             "-isysroot", sdk_path,
             "-isystem", "#{toolchain_path}/usr/include/c++/v1",
             "-isystem", "#{toolchain_path}/usr/include",
             "-isystem", "#{sdk_path}/usr/include",
             "-std=c++11", "test.cpp", "-o", "testCLT++"
      assert_includes MachO::Tools.dylibs("testCLT++"), "/usr/lib/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./testCLT++").chomp
      system "#{bin}/clang", "-v", "test.c", "-o", "testCLT"
      assert_equal "Hello World!", shell_output("./testCLT").chomp
    end

    # Testing Xcode
    if MacOS::Xcode.installed?
      system "#{bin}/clang++", "-v",
             "-isysroot", MacOS.sdk_path,
             "-isystem", "#{MacOS::Xcode.toolchain_path}/usr/include/c++/v1",
             "-isystem", "#{MacOS::Xcode.toolchain_path}/usr/include",
             "-isystem", "#{MacOS.sdk_path}/usr/include",
             "-std=c++11", "test.cpp", "-o", "testXC++"
      assert_includes MachO::Tools.dylibs("testXC++"), "/usr/lib/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./testXC++").chomp
      system "#{bin}/clang", "-v",
             "-isysroot", MacOS.sdk_path,
             "test.c", "-o", "testXC"
      assert_equal "Hello World!", shell_output("./testXC").chomp
    end

    # link against installed libc++
    # related to https://github.com/Homebrew/legacy-homebrew/issues/47149
    system "#{bin}/clang++", "-v",
           "-isystem", "#{opt_include}/c++/v1",
           "-std=c++11", "-stdlib=libc++", "test.cpp", "-o", "testlibc++",
           "-rtlib=compiler-rt", "-L#{opt_lib}", "-Wl,-rpath,#{opt_lib}"
    assert_includes (testpath/"testlibc++").dynamically_linked_libraries,
                    (opt_lib/shared_library("libc++", "1")).to_path
    (testpath/"testlibc++").dynamically_linked_libraries.each do |lib|
      refute_match(/libstdc\+\+/, lib)
      refute_match(/libgcc/, lib)
      refute_match(/libatomic/, lib)
    end
    assert_equal "Hello World!", shell_output("./testlibc++").chomp

    if OS.linux?
      # Link installed libc++, libc++abi, and libunwind archives both into
      # a position independent executable (PIE), as well as into a fully
      # position independent (PIC) DSO for things like plugins that export
      # a C-only API but internally use C++.
      #
      # FIXME: It'd be nice to be able to use flags like `-static-libstdc++`
      # together with `-stdlib=libc++` (the latter one we need anyways for
      # headers) to achieve this but those flags don't set up the correct
      # search paths or handle all of the libraries needed by `libc++` when
      # linking statically.

      system "#{bin}/clang++", "-v", "-o", "test_pie_runtimes",
                   "-pie", "-fPIC", "test.cpp", "-L#{opt_lib}",
                   "-stdlib=libc++", "-rtlib=compiler-rt",
                   "-static-libstdc++", "-lpthread", "-ldl"
      assert_equal "Hello World!", shell_output("./test_pie_runtimes").chomp
      (testpath/"test_pie_runtimes").dynamically_linked_libraries.each do |lib|
        refute_match(/lib(std)?c\+\+/, lib)
        refute_match(/libgcc/, lib)
        refute_match(/libatomic/, lib)
        refute_match(/libunwind/, lib)
      end

      (testpath/"test_plugin.cpp").write <<~EOS
        #include <iostream>
        __attribute__((visibility("default")))
        extern "C" void run_plugin() {
          std::cout << "Hello Plugin World!" << std::endl;
        }
      EOS
      (testpath/"test_plugin_main.c").write <<~EOS
        extern void run_plugin();
        int main() {
          run_plugin();
        }
      EOS

      system "#{bin}/clang++", "-v", "-o", "test_plugin.so",
             "-shared", "-fPIC", "test_plugin.cpp", "-L#{opt_lib}",
             "-stdlib=libc++", "-rtlib=compiler-rt",
             "-static-libstdc++", "-lpthread", "-ldl"
      system "#{bin}/clang", "-v",
             "test_plugin_main.c", "-o", "test_plugin_libc++",
             "test_plugin.so", "-Wl,-rpath=#{testpath}", "-rtlib=compiler-rt"
      assert_equal "Hello Plugin World!", shell_output("./test_plugin_libc++").chomp
      (testpath/"test_plugin.so").dynamically_linked_libraries.each do |lib|
        refute_match(/lib(std)?c\+\+/, lib)
        refute_match(/libgcc/, lib)
        refute_match(/libatomic/, lib)
        refute_match(/libunwind/, lib)
      end
    end

    (testpath/"scanbuildtest.cpp").write <<~EOS
      #include <iostream>
      int main() {
        int *i = new int;
        *i = 1;
        delete i;
        std::cout << *i << std::endl;
        return 0;
      }
    EOS
    assert_includes shell_output("#{bin}/scan-build #{bin}/clang++ scanbuildtest.cpp 2>&1"),
      "warning: Use of memory after it is freed"

    (testpath/"clangformattest.c").write <<~EOS
      int    main() {
          printf("Hello world!"); }
    EOS
    assert_equal "int main() { printf(\"Hello world!\"); }\n",
      shell_output("#{bin}/clang-format -style=google clangformattest.c")
  end
end
