class Llvm < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"
  revision 1
  head "https://github.com/llvm/llvm-project.git"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/llvm-10.0.0.src.tar.xz"
    sha256 "df83a44b3a9a71029049ec101fb0077ecbbdf5fe41e395215025779099a98fdf"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/clang-10.0.0.src.tar.xz"
      sha256 "885b062b00e903df72631c5f98b9579ed1ed2790f74e5646b4234fa084eacb21"
    end

    resource "clang-tools-extra" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/clang-tools-extra-10.0.0.src.tar.xz"
      sha256 "acdf8cf6574b40e6b1dabc93e76debb84a9feb6f22970126b04d4ba18b92911c"
    end

    resource "compiler-rt" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/compiler-rt-10.0.0.src.tar.xz"
      sha256 "6a7da64d3a0a7320577b68b9ca4933bdcab676e898b759850e827333c3282c75"
    end

    resource "libcxx" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/libcxx-10.0.0.src.tar.xz"
      sha256 "270f8a3f176f1981b0f6ab8aa556720988872ec2b48ed3b605d0ced8d09156c7"
    end

    resource "libunwind" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/libunwind-10.0.0.src.tar.xz"
      sha256 "09dc5ecc4714809ecf62908ae8fe8635ab476880455287036a2730966833c626"
    end

    resource "lld" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/lld-10.0.0.src.tar.xz"
      sha256 "b9a0d7c576eeef05bc06d6e954938a01c5396cee1d1e985891e0b1cf16e3d708"
    end

    resource "lldb" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/lldb-10.0.0.src.tar.xz"
      sha256 "dd1ffcb42ed033f5167089ec4c6ebe84fbca1db4a9eaebf5c614af09d89eb135"
    end

    resource "openmp" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/openmp-10.0.0.src.tar.xz"
      sha256 "3b9ff29a45d0509a1e9667a0feb43538ef402ea8cfc7df3758a01f20df08adfa"
    end

    resource "polly" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/polly-10.0.0.src.tar.xz"
      sha256 "35fba6ed628896fe529be4c10407f1b1c8a7264d40c76bced212180e701b4d97"
    end
  end

  bottle do
    cellar :any
    sha256 "732700110170de7e25f28041ce1e0b1f6fa18cb7fdc048589587f583ededa7ad" => :catalina
    sha256 "cb5730d2cae94b58ab39dd96a9a787fa9d6eb8ce4b4960895bd7e89e2eeba802" => :mojave
    sha256 "79316c473e26f4762a519db2bef9b5f4af5db2e3507aa99c1fcdd65f1cba4933" => :high_sierra
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
  depends_on "python@3.8" => :build
  depends_on :xcode => :build
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
      openmp
      polly
    ]
    runtimes = %w[
      compiler-rt
      libcxx
      libunwind
    ]

    llvmpath = buildpath/"llvm"
    unless build.head?
      llvmpath.install buildpath.children - [buildpath/".brew_home"]
      (projects + runtimes).each { |p| resource(p).stage(buildpath/p) }
    end

    # Needed until https://reviews.llvm.org/D63883 lands again.
    # Use system libcxxabi.
    rm_r "libcxxabi" if build.head?

    py_ver = "3.8"

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
      -DLIBOMP_ARCH=x86_64
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
      -DLLVM_OPTIMIZED_TABLEGEN=ON
      -DLLVM_TARGETS_TO_BUILD=all
      -DFFI_INCLUDE_DIR=#{Formula["libffi"].opt_lib}/libffi-#{Formula["libffi"].version}/include
      -DFFI_LIBRARY_DIR=#{Formula["libffi"].opt_lib}
      -DLLVM_CREATE_XCODE_TOOLCHAIN=ON
      -DLLDB_USE_SYSTEM_DEBUGSERVER=ON
      -DLLDB_ENABLE_PYTHON=OFF
      -DLLDB_ENABLE_LUA=OFF
      -DLLDB_ENABLE_LZMA=OFF
      -DLIBOMP_INSTALL_ALIASES=OFF
      -DCLANG_PYTHON_BINDINGS_VERSIONS=#{py_ver}
    ]

    sdk = MacOS.sdk_path_if_needed
    args << "-DDEFAULT_SYSROOT=#{sdk}" if sdk

    mkdir llvmpath/"build" do
      system "cmake", "-G", "Unix Makefiles", "..", *(std_cmake_args + args)
      system "make"
      system "make", "install"
      system "make", "install-xcode-toolchain"
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
  end
end
