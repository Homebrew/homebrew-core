class CodesignRequirement < Requirement
  include FileUtils
  fatal true

  satisfy(:build_env => false) do
    mktemp do
      cp "/usr/bin/false", "llvm_check"
      quiet_system "/usr/bin/codesign", "-f", "-s", "lldb_codesign", "--dryrun", "llvm_check"
    end
  end

  def message
    <<-EOS.undent
      lldb_codesign identity must be available to build with LLDB.
      See: https://llvm.org/svn/llvm-project/lldb/trunk/docs/code-signing.txt
    EOS
  end
end

class Llvm < Formula
  desc "Next-gen compiler infrastructure"
  homepage "http://llvm.org/"

  stable do
    url "http://llvm.org/releases/3.8.1/llvm-3.8.1.src.tar.xz"
    sha256 "6e82ce4adb54ff3afc18053d6981b6aed1406751b8742582ed50f04b5ab475f9"

    resource "clang" do
      url "http://llvm.org/releases/3.8.1/cfe-3.8.1.src.tar.xz"
      sha256 "4cd3836dfb4b88b597e075341cae86d61c63ce3963e45c7fe6a8bf59bb382cdf"
    end

    resource "clang-extra-tools" do
      url "http://llvm.org/releases/3.8.1/clang-tools-extra-3.8.1.src.tar.xz"
      sha256 "664a5c60220de9c290bf2a5b03d902ab731a4f95fe73a00856175ead494ec396"
    end

    resource "compiler-rt" do
      url "http://llvm.org/releases/3.8.1/compiler-rt-3.8.1.src.tar.xz"
      sha256 "0df011dae14d8700499dfc961602ee0a9572fef926202ade5dcdfe7858411e5c"
    end

    # Only required to build & run Compiler-RT tests on OS X, optional otherwise.
    # http://clang.llvm.org/get_started.html
    resource "libcxx" do
      url "http://llvm.org/releases/3.8.1/libcxx-3.8.1.src.tar.xz"
      sha256 "77d7f3784c88096d785bd705fa1bab7031ce184cd91ba8a7008abf55264eeecc"
    end

    resource "libunwind" do
      url "http://llvm.org/releases/3.8.1/libunwind-3.8.1.src.tar.xz"
      sha256 "21e58ce09a5982255ecf86b86359179ddb0be4f8f284a95be14201df90e48453"
    end

    resource "lld" do
      url "http://llvm.org/releases/3.8.1/lld-3.8.1.src.tar.xz"
      sha256 "2bd9be8bb18d82f7f59e31ea33b4e58387dbdef0bc11d5c9fcd5ce9a4b16dc00"
    end

    resource "lldb" do
      url "http://llvm.org/releases/3.8.1/lldb-3.8.1.src.tar.xz"
      sha256 "349148116a47e39dcb5d5042f10d8a6357d2c865034563283ca512f81cdce8a3"
    end

    resource "openmp" do
      url "http://llvm.org/releases/3.8.1/openmp-3.8.1.src.tar.xz"
      sha256 "68fcde6ef34e0275884a2de3450a31e931caf1d6fda8606ef14f89c4123617dc"
    end

    resource "polly" do
      url "http://llvm.org/releases/3.8.1/polly-3.8.1.src.tar.xz"
      sha256 "453c27e1581614bb3b6351bf5a2da2939563ea9d1de99c420f85ca8d87b928a2"
    end
  end

  bottle do
    sha256 "ce2d461a9aff5e4b91bdb76f855be312e0b2f3e8a92950ff8628a465ea9f71cb" => :sierra
    sha256 "3198e307a4360b428c953cc00408e5b80bd07b4946b96db8bbbfb03f81cb4aa2" => :el_capitan
    sha256 "1957948bbbbee09eac331b2b0bad399b04f94d8c79271ea0aee4ac99ab7e6100" => :yosemite
    sha256 "dba4556fbb273ef07dcc135a32eabb4b2eafb874ceecb9732b2ccaeded965a80" => :mavericks
  end

  head do
    url "http://llvm.org/git/llvm.git"

    resource "clang" do
      url "http://llvm.org/git/clang.git"
    end

    resource "clang-extra-tools" do
      url "http://llvm.org/git/clang-tools-extra.git"
    end

    resource "compiler-rt" do
      url "http://llvm.org/git/compiler-rt.git"
    end

    resource "libcxx" do
      url "http://llvm.org/git/libcxx.git"
    end

    resource "libunwind" do
      url "http://llvm.org/git/libunwind.git"
    end

    resource "lld" do
      url "http://llvm.org/git/lld.git"
    end

    resource "lldb" do
      url "http://llvm.org/git/lldb.git"
    end

    resource "openmp" do
      url "http://llvm.org/git/openmp.git"
    end

    resource "polly" do
      url "http://llvm.org/git/polly.git"
    end
  end

  keg_only :provided_by_osx

  option :universal
  option "without-compiler-rt", "Do not build Clang runtime support libraries for code sanitizers, builtins, and profiling"
  option "without-libcxx", "Do not build libc++ standard library"
  option "with-toolchain", "Build with Toolchain to facilitate overriding system compiler"
  option "without-libunwind", "Do not build libunwind library"
  option "without-lld", "Do not build LLD linker"
  option "with-lldb", "Build LLDB debugger"
  option "with-python", "Build bindings against custom Python"
  option "without-rtti", "Build without C++ RTTI or exception handling"
  option "without-utils", "Do not install utility binaries"
  option "without-polly", "Do not build Polly optimizer"
  option "with-test", "Build LLVM unit tests"
  option "with-shared-libs", "Build shared instead of static libraries"
  option "without-libffi", "Do not use libffi to call external functions"
  option "with-all-targets", "Build all targets. Default targets: AMDGPU, ARM, NVPTX, and X86"

  depends_on "libffi" => :recommended # http://llvm.org/docs/GettingStarted.html#requirement
  depends_on "graphviz" => :optional # for the 'dot' tool (lldb)
  depends_on "ocaml" => :optional

  if MacOS.version <= :snow_leopard
    depends_on :python
  else
    depends_on :python => :optional
  end
  depends_on "cmake" => :build

  if build.with? "lldb"
    depends_on "swig" if MacOS.version >= :lion
    depends_on CodesignRequirement
  end

  # Apple's libstdc++ is too old to build LLVM
  fails_with :llvm
  # According to the official llvm readme, GCC 4.7+ is required
  fails_with :gcc_4_0
  fails_with :gcc
  ("4.3".."4.6").each do |n|
    fails_with :gcc => n
  end

  def build_libcxx?
    build.with?("libcxx") || !MacOS::CLT.installed?
  end

  def install
    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    (buildpath/"tools/clang").install resource("clang")
    (buildpath/"tools/clang/tools/extra").install resource("clang-extra-tools")
    (buildpath/"projects/openmp").install resource("openmp")
    (buildpath/"projects/libcxx").install resource("libcxx") if build_libcxx?
    (buildpath/"projects/libunwind").install resource("libunwind") if build.with? "libunwind"
    (buildpath/"tools/lld").install resource("lld") if build.with? "lld"
    (buildpath/"tools/polly").install resource("polly") if build.with? "polly"

    if build.with? "lldb"
      if build.with? "python"
        pyhome = `python-config --prefix`.chomp
        ENV["PYTHONHOME"] = pyhome
        pylib = "#{pyhome}/lib/libpython2.7.dylib"
        pyinclude = "#{pyhome}/include/python2.7"
      end
      (buildpath/"tools/lldb").install resource("lldb")

      # Building lldb requires a code signing certificate.
      # The instructions provided by llvm creates this certificate in the
      # user's login keychain. Unfortunately, the login keychain is not in
      # the search path in a superenv build. The following three lines add
      # the login keychain to ~/Library/Preferences/com.apple.security.plist,
      # which adds it to the superenv keychain search path.
      mkdir_p "#{ENV["HOME"]}/Library/Preferences"
      username = ENV["USER"]
      system "security", "list-keychains", "-d", "user", "-s", "/Users/#{username}/Library/Keychains/login.keychain"
    end

    if build.with? "compiler-rt"
      (buildpath/"projects/compiler-rt").install resource("compiler-rt")

      # compiler-rt has some iOS simulator features that require i386 symbols
      # I'm assuming the rest of clang needs support too for 32-bit compilation
      # to work correctly, but if not, perhaps universal binaries could be
      # limited to compiler-rt. llvm makes this somewhat easier because compiler-rt
      # can almost be treated as an entirely different build from llvm.
      ENV.permit_arch_flags
    end

    args = %w[
      -DLLVM_OPTIMIZED_TABLEGEN=ON
    ]
    args << "-DLLVM_TARGETS_TO_BUILD=#{build.with?("all-targets") ? "all" : "AMDGPU;ARM;NVPTX;X86"}"
    args << "-DLIBOMP_ARCH=x86_64"
    args << "-DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON" if build.with? "compiler-rt"
    args << "-DLLVM_CREATE_XCODE_TOOLCHAIN=ON" if build.with? "toolchain"

    if build.with? "shared-libs"
      args << "-DBUILD_SHARED_LIBS=ON"
      args << "-DLIBOMP_ENABLE_SHARED=ON"
    else
      args << "-DLLVM_BUILD_LLVM_DYLIB=ON"
    end

    if build.with? "test"
      args << "-DLLVM_BUILD_TESTS=ON"
      args << "-DLLVM_ABI_BREAKING_CHECKS=WITH_ASSERTS"
    end

    if build.with? "rtti"
      args << "-DLLVM_ENABLE_RTTI=ON"
      args << "-DLLVM_ENABLE_EH=ON"
    end
    args << "-DLLVM_INSTALL_UTILS=ON" if build.with? "utils"
    args << "-DLLVM_ENABLE_LIBCXX=ON" if build_libcxx?

    if build.with?("lldb") && build.with?("python")
      args << "-DLLDB_RELOCATABLE_PYTHON=ON"
      args << "-DPYTHON_LIBRARY=#{pylib}"
      args << "-DPYTHON_INCLUDE_DIR=#{pyinclude}"
    end

    if build.with? "libffi"
      args << "-DLLVM_ENABLE_FFI=ON"
      args << "-DFFI_INCLUDE_DIR=#{Formula["libffi"].opt_lib}/libffi-#{Formula["libffi"].version}/include"
      args << "-DFFI_LIBRARY_DIR=#{Formula["libffi"].opt_lib}"
    end

    if build.universal?
      ENV.permit_arch_flags
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    if build.with? "polly"
      args << "-DWITH_POLLY=ON"
      args << "-DLINK_POLLY_INTO_TOOLS=ON"
    end

    mktemp do
      system "cmake", "-G", "Unix Makefiles", buildpath, *(std_cmake_args + args)
      system "make"
      system "make", "install"
      system "make", "install-xcode-toolchain" if build.with? "toolchain"
    end

    (share/"clang/tools").install Dir["tools/clang/tools/scan-{build,view}"]
    inreplace "#{share}/clang/tools/scan-build/bin/scan-build", "$RealBin/bin/clang", "#{bin}/clang"
    bin.install_symlink share/"clang/tools/scan-build/bin/scan-build", share/"clang/tools/scan-view/bin/scan-view"
    man1.install_symlink share/"clang/tools/scan-build/man/scan-build.1"

    # install llvm python bindings
    (lib/"python2.7/site-packages").install buildpath/"bindings/python/llvm"
    (lib/"python2.7/site-packages").install buildpath/"tools/clang/bindings/python/clang"
  end

  def caveats
    s = <<-EOS.undent
      LLVM executables are installed in #{opt_bin}.
      Extra tools are installed in #{opt_pkgshare}.
    EOS

    if build_libcxx?
      s += <<-EOS.undent
        To use the bundled libc++ please add the following LDFLAGS:
          LDFLAGS="-L#{opt_lib} -Wl,-rpath,#{opt_lib}"
      EOS
    end

    s
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/llvm-config --prefix").chomp

    (testpath/"omptest.c").write <<-EOS.undent
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

    system "#{bin}/clang", "-L#{lib}", "-fopenmp", "-nobuiltininc",
                           "-I#{lib}/clang/#{version}/include",
                           "omptest.c", "-o", "omptest"
    testresult = shell_output("./omptest")

    sorted_testresult = testresult.split("\n").sort.join("\n")
    expected_result = <<-EOS.undent
      Hello from thread 0, nthreads 4
      Hello from thread 1, nthreads 4
      Hello from thread 2, nthreads 4
      Hello from thread 3, nthreads 4
    EOS
    assert_equal expected_result.strip, sorted_testresult.strip

    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>

      int main()
      {
        printf("Hello World!\\n");
        return 0;
      }
    EOS

    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>

      int main()
      {
        std::cout << "Hello World!" << std::endl;
        return 0;
      }
    EOS

    # Testing Command Line Tools
    if MacOS::CLT.installed?
      libclangclt = Dir["/Library/Developer/CommandLineTools/usr/lib/clang/#{DevelopmentTools.clang_version}*"].last { |f| File.directory? f }

      system "#{bin}/clang++", "-v", "-nostdinc",
              "-I/Library/Developer/CommandLineTools/usr/include/c++/v1",
              "-I#{libclangclt}/include",
              "-I/usr/include", # need it because /Library/.../usr/include/c++/v1/iosfwd refers to <wchar.h>, which CLT installs to /usr/include
              "test.cpp", "-o", "testCLT++"
      assert_match "/usr/lib/libc++.1.dylib", shell_output("otool -L ./testCLT++").chomp
      assert_equal "Hello World!", shell_output("./testCLT++").chomp

      system "#{bin}/clang", "-v", "-nostdinc",
              "-I/usr/include", # this is where CLT installs stdio.h
              "test.c", "-o", "testCLT"
      assert_equal "Hello World!", shell_output("./testCLT").chomp
    end

    # Testing Xcode
    if MacOS::Xcode.installed?
      libclangxc = Dir["#{MacOS::Xcode.toolchain_path}/usr/lib/clang/#{DevelopmentTools.clang_version}*"].last { |f| File.directory? f }

      system "#{bin}/clang++", "-v", "-nostdinc",
              "-I#{MacOS::Xcode.toolchain_path}/usr/include/c++/v1",
              "-I#{libclangxc}/include",
              "-I#{MacOS.sdk_path}/usr/include",
              "test.cpp", "-o", "testXC++"
      assert_match "/usr/lib/libc++.1.dylib", shell_output("otool -L ./testXC++").chomp
      assert_equal "Hello World!", shell_output("./testXC++").chomp

      system "#{bin}/clang", "-v", "-nostdinc",
              "-I#{MacOS.sdk_path}/usr/include",
              "test.c", "-o", "testXC"
      assert_equal "Hello World!", shell_output("./testXC").chomp
    end

    # link against installed libc++
    # related to https://github.com/Homebrew/legacy-homebrew/issues/47149
    if build_libcxx?
      system "#{bin}/clang++", "-v", "-nostdinc",
              "-std=c++11", "-stdlib=libc++",
              "-I#{MacOS::Xcode.toolchain_path}/usr/include/c++/v1",
              "-I#{libclangxc}/include",
              "-I#{MacOS.sdk_path}/usr/include",
              "-L#{lib}",
              "-Wl,-rpath,#{lib}", "test.cpp", "-o", "test"
      assert_match "#{opt_lib}/libc++.1.dylib", shell_output("otool -L ./test").chomp
      assert_equal "Hello World!", shell_output("./test").chomp
    end
  end
end
