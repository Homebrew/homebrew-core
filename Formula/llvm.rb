class Llvm < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  head "https://github.com/llvm/llvm-project.git"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.0/llvm-project-11.0.0.tar.xz"
    sha256 "b7b639fc675fa1c86dd6d0bc32267be9eb34451748d2efd03f674b773000e92b"

    patch do
      url "https://github.com/llvm/llvm-project/commit/c86f56e32e724c6018e579bb2bc11e667c96fc96.patch?full_index=1"
      sha256 "6e13e01b4f9037bb6f43f96cb752d23b367fe7db4b66d9bf2a4aeab9234b740a"
    end

    patch do
      url "https://github.com/llvm/llvm-project/commit/31e5f7120bdd2f76337686d9d169b1c00e6ee69c.patch?full_index=1"
      sha256 "f025110aa6bf80bd46d64a0e2b1e2064d165353cd7893bef570b6afba7e90b4d"
    end

    patch do
      url "https://github.com/llvm/llvm-project/commit/3c7bfbd6831b2144229734892182d403e46d7baf.patch?full_index=1"
      sha256 "62014ddad6d5c485ecedafe3277fe7978f3f61c940976e3e642536726abaeb68"
    end

    patch do
      url "https://github.com/llvm/llvm-project/commit/c4d7536136b331bada079b2afbb2bd09ad8296bf.patch?full_index=1"
      sha256 "2b894cbaf990510969bf149697882c86a068a1d704e749afa5d7b71b6ee2eb9f"
    end
  end

  livecheck do
    url :homepage
    regex(/LLVM (\d+.\d+.\d+)/i)
  end

  bottle do
    cellar :any
    sha256 "d8ad1f1c539c4c643017882878d60bc3a45b7e4a67e4d697ac071d20926d121c" => :catalina
    sha256 "7a5600152cc5d8c7043b9c92db2194e757e17cae6f9e0a498468c3921efb9770" => :mojave
    sha256 "9ce34ed1a0be220267b76e8c81d7b4955cca470957a4f921fe7e380b0a81b67f" => :high_sierra
  end

  # Clang cannot find system headers if Xcode CLT is not installed
  pour_bottle? do
    reason "The bottle needs the Xcode CLT to be installed."
    satisfy { MacOS::CLT.installed? }
  end

  keg_only :provided_by_macos

  # https://llvm.org/docs/GettingStarted.html#requirement
  # We intentionally use Make instead of Ninja.
  # See: Homebrew/homebrew-core/issues/35513
  depends_on "cmake" => :build
  depends_on "python@3.9" => :build
  depends_on "libffi"

  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    projects = %w[
      clang
      clang-tools-extra
      lld
      lldb
      polly
    ]
    # OpenMP currently fails to build on ARM
    # https://github.com/Homebrew/brew/issues/7857#issuecomment-661484670
    projects << "openmp" unless Hardware::CPU.arm?
    runtimes = %w[
      compiler-rt
      libcxx
      libcxxabi
      libunwind
    ]

    py_ver = "3.9"

    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    # compiler-rt has some iOS simulator features that require i386 symbols
    # I'm assuming the rest of clang needs support too for 32-bit compilation
    # to work correctly, but if not, perhaps universal binaries could be
    # limited to compiler-rt. llvm makes this somewhat easier because compiler-rt
    # can almost be treated as an entirely different build from llvm.
    ENV.permit_arch_flags

    args = %W[
      -DLLVM_ENABLE_PROJECTS=#{projects.join(";")}
      -DLLVM_ENABLE_RUNTIMES=#{runtimes.join(";")}
      -DLLVM_POLLY_LINK_INTO_TOOLS=ON
      -DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON
      -DLLVM_LINK_LLVM_DYLIB=ON
      -DLLVM_BUILD_LLVM_C_DYLIB=ON
      -DLLVM_ENABLE_EH=ON
      -DLLVM_ENABLE_FFI=ON
      -DLLVM_ENABLE_LIBCXX=ON
      -DLLVM_ENABLE_RTTI=ON
      -DLLVM_INCLUDE_DOCS=OFF
      -DLLVM_INCLUDE_TESTS=OFF
      -DLLVM_INSTALL_UTILS=ON
      -DLLVM_ENABLE_Z3_SOLVER=OFF
      -DLLVM_OPTIMIZED_TABLEGEN=ON
      -DLLVM_TARGETS_TO_BUILD=all
      -DFFI_INCLUDE_DIR=#{Formula["libffi"].opt_lib}/libffi-#{Formula["libffi"].version}/include
      -DFFI_LIBRARY_DIR=#{Formula["libffi"].opt_lib}
      -DLLVM_CREATE_XCODE_TOOLCHAIN=#{MacOS::Xcode.installed? ? "ON" : "OFF"}
      -DLLDB_USE_SYSTEM_DEBUGSERVER=ON
      -DLLDB_ENABLE_PYTHON=OFF
      -DLLDB_ENABLE_LUA=OFF
      -DLLDB_ENABLE_LZMA=OFF
      -DLIBOMP_INSTALL_ALIASES=OFF
      -DCLANG_PYTHON_BINDINGS_VERSIONS=#{py_ver}
    ]

    sdk = MacOS.sdk_path_if_needed
    args << "-DDEFAULT_SYSROOT=#{sdk}" if sdk

    if MacOS.version == :mojave && MacOS::CLT.installed?
      # Mojave CLT linker via software update is older than Xcode.
      # Use it to retain compatibility.
      args << "-DCMAKE_LINKER=/Library/Developer/CommandLineTools/usr/bin/ld"
    end

    llvmpath = buildpath/"llvm"
    mkdir llvmpath/"build" do
      system "cmake", "-G", "Unix Makefiles", "..", *(std_cmake_args + args)
      system "make"
      system "make", "install"
      system "make", "install-xcode-toolchain" if MacOS::Xcode.installed?
    end

    # Install LLVM Python bindings
    # Clang Python bindings are installed by CMake
    (lib/"python#{py_ver}/site-packages").install llvmpath/"bindings/python/llvm"

    # Install Emacs modes
    elisp.install Dir[llvmpath/"utils/emacs/*.el"] + Dir[share/"clang/*.el"]
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

    system "#{bin}/clang", "-L#{lib}", "-fopenmp", "-nobuiltininc",
                           "-I#{lib}/clang/#{clean_version}/include",
                           "omptest.c", "-o", "omptest"
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
    assert_includes MachO::Tools.dylibs("test++"), "/usr/lib/libc++.1.dylib"
    assert_equal "Hello World!", shell_output("./test++").chomp
    system "#{bin}/clang", "-v", "test.c", "-o", "test"
    assert_equal "Hello World!", shell_output("./test").chomp

    # Testing Command Line Tools
    if MacOS::CLT.installed?
      toolchain_path = "/Library/Developer/CommandLineTools"
      system "#{bin}/clang++", "-v",
             "-isysroot", MacOS::CLT.sdk_path,
             "-isystem", "#{toolchain_path}/usr/include/c++/v1",
             "-isystem", "#{toolchain_path}/usr/include",
             "-isystem", "#{MacOS::CLT.sdk_path}/usr/include",
             "-std=c++11", "test.cpp", "-o", "testCLT++"
      assert_includes MachO::Tools.dylibs("testCLT++"), "/usr/lib/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./testCLT++").chomp
      system "#{bin}/clang", "-v", "test.c", "-o", "testCLT"
      assert_equal "Hello World!", shell_output("./testCLT").chomp
    end

    # Testing Xcode
    if MacOS::Xcode.installed?
      system "#{bin}/clang++", "-v",
             "-isysroot", MacOS::Xcode.sdk_path,
             "-isystem", "#{MacOS::Xcode.toolchain_path}/usr/include/c++/v1",
             "-isystem", "#{MacOS::Xcode.toolchain_path}/usr/include",
             "-isystem", "#{MacOS::Xcode.sdk_path}/usr/include",
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
           "-L#{opt_lib}", "-Wl,-rpath,#{opt_lib}"
    assert_includes MachO::Tools.dylibs("testlibc++"), "#{opt_lib}/libc++.1.dylib"
    assert_equal "Hello World!", shell_output("./testlibc++").chomp

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
    assert_includes shell_output("#{bin}/scan-build clang++ scanbuildtest.cpp 2>&1"),
      "warning: Use of memory after it is freed"

    (testpath/"clangformattest.c").write <<~EOS
      int    main() {
          printf("Hello world!"); }
    EOS
    assert_equal "int main() { printf(\"Hello world!\"); }\n",
      shell_output("#{bin}/clang-format -style=google clangformattest.c")

    # Ensure LLVM did not regress output of `llvm-config --system-libs` which for a time
    # was known to output incorrect linker flags; e.g., `-llibxml2.tbd` instead of `-lxml2`.
    # On the other hand, note that a fully qualified path to `dylib` or `tbd` is OK, e.g.,
    # `/usr/local/lib/libxml2.tbd` or `/usr/local/lib/libxml2.dylib`.
    shell_output("#{bin}/llvm-config --system-libs").chomp.strip.split(" ").each do |lib|
      if lib.start_with?("-l")
        assert !lib.end_with?(".tbd"), "expected abs path when lib reported as .tbd"
        assert !lib.end_with?(".dylib"), "expected abs path when lib reported as .dylib"
      else
        p = Pathname.new(lib)
        if p.extname == ".tbd" || p.extname == ".dylib"
          assert p.absolute?, "expected abs path when lib reported as .tbd or .dylib"
        end
      end
    end
  end
end
