class LlvmAT7 < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"
  url "https://releases.llvm.org/7.1.0/llvm-7.1.0.src.tar.xz"
  sha256 "1bcc9b285074ded87b88faaedddb88e6b5d6c331dfcfb57d7f3393dd622b3764"
  license "NCSA"
  revision 3

  bottle do
    sha256 cellar: :any,                 catalina:     "ea1162f57d529a64b516055b9d1756dfa6402177f0f149453da9310580e063ec"
    sha256 cellar: :any,                 mojave:       "6deab84061586ffe36ab8755f9f3b3b792b0829a7933716aa2bf39f389a14ff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "17e8b89b11ca5faa71904c05483a96fda1e2268c9c8c76f7607a983e93f2a877"
  end

  # Clang cannot find system headers if Xcode CLT is not installed
  pour_bottle? only_if: :clt_installed

  keg_only :versioned_formula

  # Deprecated in homebrew since 2022-05-29
  disable! date: "2022-09-30", because: :versioned_formula

  # https://llvm.org/docs/GettingStarted.html#requirement
  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on arch: :x86_64
  depends_on "libffi"
  depends_on maximum_macos: :catalina # Needs patches backported to LLVM 8 and 9 to work on Big Sur

  uses_from_macos "libedit" # llvm requires <histedit.h>
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "binutils" # needed for gold and strip
    depends_on "glibc" if Formula["glibc"].any_version_installed?
    depends_on "libelf" # openmp requires <gelf.h>
    depends_on "python@3.8"
  end

  resource "clang" do
    url "https://releases.llvm.org/7.1.0/cfe-7.1.0.src.tar.xz"
    sha256 "e97dc472aae52197a4d5e0185eb8f9e04d7575d2dc2b12194ddc768e0f8a846d"
  end

  resource "clang-extra-tools" do
    url "https://releases.llvm.org/7.1.0/clang-tools-extra-7.1.0.src.tar.xz"
    sha256 "1ce0042c48ecea839ce67b87e9739cf18e7a5c2b3b9a36d177d00979609b6451"
  end

  resource "compiler-rt" do
    url "https://releases.llvm.org/7.1.0/compiler-rt-7.1.0.src.tar.xz"
    sha256 "057bdac0581215b5ceb39edfd5bbef9eb79578f16a8908349f3066251fba88d8"
  end

  resource "libcxx" do
    url "https://releases.llvm.org/7.1.0/libcxx-7.1.0.src.tar.xz"
    sha256 "4442b408eaea3c1e4aa2cf21da38aba9f0856b4b522b1c3d555c3251af62b04e"
  end

  resource "libcxxabi" do
    on_linux do
      url "https://releases.llvm.org/7.1.0/libcxxabi-7.1.0.src.tar.xz"
      sha256 "6241e81f7c62e11cf54f865ae2d5b8e93943e5f007ccbb59f88f2b289bee98fd"
    end
  end

  resource "libunwind" do
    url "https://releases.llvm.org/7.1.0/libunwind-7.1.0.src.tar.xz"
    sha256 "174a7fc9eb7422c8ea96993649be0f80ca5937f3fe000c40c3d15b1074d7ad0c"
  end

  resource "lld" do
    url "https://releases.llvm.org/7.1.0/lld-7.1.0.src.tar.xz"
    sha256 "a10f274a0a09408eaf9c088dec6fb2254f7d641221437763c94546cbfe595867"
  end

  resource "openmp" do
    url "https://releases.llvm.org/7.1.0/openmp-7.1.0.src.tar.xz"
    sha256 "1ee73aa1eef4ef7f75c96b24bf02445440602064c0074891ca5344a63f1fe5b5"
  end

  resource "polly" do
    url "https://releases.llvm.org/7.1.0/polly-7.1.0.src.tar.xz"
    sha256 "305454f72db5e30def3f48e2dc56ce62f9c52c3b9278b8f357a093a588b6139b"
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
      -DLLVM_INCLUDE_DOCS=OFF
      -DLLVM_INSTALL_UTILS=ON
      -DLLVM_OPTIMIZED_TABLEGEN=ON
      -DLLVM_TARGETS_TO_BUILD=all
      -DWITH_POLLY=ON
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
    end

    if OS.linux?
      args << "-DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON"
      args << "-DLLVM_CREATE_XCODE_TOOLCHAIN=OFF"
      args << "-DLLVM_ENABLE_LIBCXX=OFF"
      args << "-DCLANG_DEFAULT_CXX_STDLIB=libstdc++"

      # Enable llvm gold plugin for LTO
      args << "-DLLVM_BINUTILS_INCDIR=#{Formula["binutils"].opt_include}"

      # Add flags to build shared and static libc++ which are independent of GCC
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

      # Don't pass -rtlib as an argument to GCC because it doesn't understand it.
      inreplace (buildpath/"projects/libcxx/CMakeLists.txt"),
        "list(APPEND LIBCXX_LINK_FLAGS \"-rtlib=compiler-rt\")", ""
      inreplace (buildpath/"projects/libcxxabi/CMakeLists.txt"),
        "list(APPEND LIBCXXABI_LINK_FLAGS \"-rtlib=compiler-rt\")", ""
      inreplace (buildpath/"projects/libunwind/CMakeLists.txt"),
        "list(APPEND LIBUNWIND_LINK_FLAGS \"-rtlib=compiler-rt\")", ""
    end

    if MacOS.version >= :mojave
      sdk_path = MacOS::CLT.installed? ? "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk" : MacOS.sdk_path
      args << "-DDEFAULT_SYSROOT=#{sdk_path}"
    end

    mkdir "build" do
      system "cmake", "-G", "Unix Makefiles", "..", *(std_cmake_args + args)
      system "make"
      system "make", "install"
      system "make", "install-xcode-toolchain" if MacOS::Xcode.installed?
    end

    (share/"cmake").install "cmake/modules"
    (share/"clang/tools").install Dir["tools/clang/tools/scan-{build,view}"]

    # scan-build is in Perl, so the @ in our path needs to be escaped
    inreplace "#{share}/clang/tools/scan-build/bin/scan-build",
              "$RealBin/bin/clang", "#{bin}/clang".gsub("@", "\\@")

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
    assert_includes shell_output("#{bin}/scan-build --use-analyzer #{bin}/clang++ " \
                                 "#{bin}/clang++ scanbuildtest.cpp 2>&1"),
      "warning: Use of memory after it is freed"

    (testpath/"clangformattest.c").write <<~EOS
      int    main() {
          printf("Hello world!"); }
    EOS
    assert_equal "int main() { printf(\"Hello world!\"); }\n",
      shell_output("#{bin}/clang-format -style=google clangformattest.c")
  end
end
