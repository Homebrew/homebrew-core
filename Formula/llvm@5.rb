class LlvmAT5 < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"
  url "https://releases.llvm.org/5.0.2/llvm-5.0.2.src.tar.xz"
  sha256 "d522eda97835a9c75f0b88ddc81437e5edbb87dc2740686cb8647763855c2b3c"

  bottle do
    cellar :any
    sha256 "be24cba8fab8f07504a75c62888fa208f6a508bbfb416af3385a9704461ae08d" => :mojave
    sha256 "d76f7ca753dd3464883c0ec21ce6751c7de02b3db9ee4fad19925e5283d902b8" => :high_sierra
    sha256 "a2eb1622d8ff63b6b38f3611ed5c0d9f5a609468d279d90ae10fb583c3388392" => :sierra
    sha256 "d240e166d5116243fce9d518da0167678aaa3b17151be702cdf9d38f57f27e54" => :el_capitan
  end

  keg_only :versioned_formula

  option "with-toolchain", "Build with Toolchain to facilitate overriding system compiler"
  option "with-lldb", "Build LLDB debugger"
  option "with-python@2", "Build bindings against Homebrew's Python 2"

  deprecated_option "with-python" => "with-python@2"

  depends_on "cmake" => :build
  depends_on "libffi"

  if MacOS.version <= :snow_leopard
    depends_on "python@2"
  else
    depends_on "python@2" => :optional
  end

  if build.with? "lldb"
    depends_on "swig" if MacOS.version >= :lion
    depends_on :codesign => [{
      :identity => "lldb_codesign",
      :with => "LLDB",
      :url => "https://llvm.org/svn/llvm-project/lldb/trunk/docs/code-signing.txt",
    }]
  end

  # According to the official llvm readme, GCC 4.7+ is required
  fails_with :gcc_4_0
  fails_with :gcc_4_2
  ("4.3".."4.6").each do |n|
    fails_with :gcc => n
  end

  resource "clang" do
    url "https://releases.llvm.org/5.0.2/cfe-5.0.2.src.tar.xz"
    sha256 "fa9ce9724abdb68f166deea0af1f71ca0dfa9af8f7e1261f2cae63c280282800"
  end

  resource "clang-extra-tools" do
    url "https://releases.llvm.org/5.0.2/clang-tools-extra-5.0.2.src.tar.xz"
    sha256 "a3362a854ba4a60336b21a95612f647f4b6de0afd88858f2420e41c5a31b0b05"
  end

  resource "compiler-rt" do
    url "https://releases.llvm.org/5.0.2/compiler-rt-5.0.2.src.tar.xz"
    sha256 "3efe9ddf3f69e0c0a45cde57ee93911f36f3ab5f2a7f6ab8c8efb3db9b24ed46"
  end

  resource "libcxx" do
    url "https://releases.llvm.org/5.0.2/libcxx-5.0.2.src.tar.xz"
    sha256 "6edf88e913175536e1182058753fff2365e388e017a9ec7427feb9929c52e298"
  end

  resource "libunwind" do
    url "https://releases.llvm.org/5.0.2/libunwind-5.0.2.src.tar.xz"
    sha256 "706e43c69c7be0fdeb55ebdf653cf47ca77e471d1584f1dbf12a568a93df9928"
  end

  resource "lld" do
    url "https://releases.llvm.org/5.0.2/lld-5.0.2.src.tar.xz"
    sha256 "46456d72ec411c6d5327ad3fea1358296f0dfe508caf1fa63ce4184f652e07aa"
  end

  resource "lldb" do
    url "https://releases.llvm.org/5.0.2/lldb-5.0.2.src.tar.xz"
    sha256 "78ba05326249b4d7577db56d16b2a7ffea43fc51e8592b0a1ac4d2ef87514216"

    # Fixes "error: no type named 'pid_t' in the global namespace"
    # https://github.com/Homebrew/homebrew-core/issues/17839
    # Already fixed in upstream trunk
    patch do
      url "https://github.com/llvm-mirror/lldb/commit/324f93b5e30.patch?full_index=1"
      sha256 "f23fc92c2d61bf6c8bc6865994a75264fafba6ae435e4d2f4cc8327004523fb1"
    end
  end

  resource "openmp" do
    url "https://releases.llvm.org/5.0.2/openmp-5.0.2.src.tar.xz"
    sha256 "39ca542c540608d95d3299a474836a7b5f8377bcc5a68493379872738c28565c"
  end

  resource "polly" do
    url "https://releases.llvm.org/5.0.2/polly-5.0.2.src.tar.xz"
    sha256 "dda84e48b2195768c4ef25893edd5eeca731bed7e80a2376119dfbc3350e91b8"
  end

  def install
    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    if build.with? "python@2"
      ENV.prepend_path "PATH", Formula["python@2"].opt_libexec/"bin"
    end

    (buildpath/"tools/clang").install resource("clang")
    (buildpath/"tools/clang/tools/extra").install resource("clang-extra-tools")
    (buildpath/"projects/openmp").install resource("openmp")
    (buildpath/"projects/libcxx").install resource("libcxx")
    (buildpath/"projects/libunwind").install resource("libunwind")
    (buildpath/"tools/lld").install resource("lld")
    (buildpath/"tools/polly").install resource("polly")

    if build.with? "lldb"
      if build.with? "python@2"
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

    (buildpath/"projects/compiler-rt").install resource("compiler-rt")

    # compiler-rt has some iOS simulator features that require i386 symbols
    # I'm assuming the rest of clang needs support too for 32-bit compilation
    # to work correctly, but if not, perhaps universal binaries could be
    # limited to compiler-rt. llvm makes this somewhat easier because compiler-rt
    # can almost be treated as an entirely different build from llvm.
    ENV.permit_arch_flags

    args = %W[
      -DLIBOMP_ARCH=x86_64
      -DLINK_POLLY_INTO_TOOLS=ON
      -DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON
      -DLLVM_BUILD_LLVM_DYLIB=ON
      -DLLVM_ENABLE_EH=ON
      -DLLVM_ENABLE_FFI=ON
      -DLLVM_ENABLE_LIBCXX=ON
      -DLLVM_ENABLE_RTTI=ON
      -DLLVM_INCLUDE_DOCS=OFF
      -DLLVM_INSTALL_UTILS=ON
      -DLLVM_OPTIMIZED_TABLEGEN=ON
      -DLLVM_TARGETS_TO_BUILD=all
      -DWITH_POLLY=ON
      -DFFI_INCLUDE_DIR=#{Formula["libffi"].opt_lib}/libffi-#{Formula["libffi"].version}/include
      -DFFI_LIBRARY_DIR=#{Formula["libffi"].opt_lib}
    ]
    args << "-DLLVM_CREATE_XCODE_TOOLCHAIN=ON" if build.with? "toolchain"

    if build.with?("lldb") && build.with?("python@2")
      args << "-DLLDB_RELOCATABLE_PYTHON=ON"
      args << "-DPYTHON_LIBRARY=#{pylib}"
      args << "-DPYTHON_INCLUDE_DIR=#{pyinclude}"
    end

    mkdir "build" do
      system "cmake", "-G", "Unix Makefiles", "..", *(std_cmake_args + args)
      system "make"
      system "make", "install"
      system "make", "install-xcode-toolchain" if build.with? "toolchain"
    end

    (share/"clang/tools").install Dir["tools/clang/tools/scan-{build,view}"]
    (share/"cmake").install "cmake/modules"
    inreplace "#{share}/clang/tools/scan-build/bin/scan-build", "$RealBin/bin/clang", "#{bin}/clang"
    bin.install_symlink share/"clang/tools/scan-build/bin/scan-build", share/"clang/tools/scan-view/bin/scan-view"
    man1.install_symlink share/"clang/tools/scan-build/man/scan-build.1"

    # install llvm python bindings
    (lib/"python2.7/site-packages").install buildpath/"bindings/python/llvm"
    (lib/"python2.7/site-packages").install buildpath/"tools/clang/bindings/python/clang"
  end

  def caveats; <<~EOS
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

    system "#{bin}/clang", "-L#{lib}", "-fopenmp", "-nobuiltininc",
                           "-I#{lib}/clang/#{version}/include",
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

    # Testing Command Line Tools
    if MacOS::CLT.installed?
      libclangclt = Dir["/Library/Developer/CommandLineTools/usr/lib/clang/#{MacOS::CLT.version.to_i}*"].last { |f| File.directory? f }

      system "#{bin}/clang++", "-v", "-nostdinc",
              "-I/Library/Developer/CommandLineTools/usr/include/c++/v1",
              "-I#{libclangclt}/include",
              "-I/usr/include", # need it because /Library/.../usr/include/c++/v1/iosfwd refers to <wchar.h>, which CLT installs to /usr/include
              "test.cpp", "-o", "testCLT++"
      assert_includes MachO::Tools.dylibs("testCLT++"), "/usr/lib/libc++.1.dylib"
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
      assert_includes MachO::Tools.dylibs("testXC++"), "/usr/lib/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./testXC++").chomp

      system "#{bin}/clang", "-v", "-nostdinc",
              "-I#{MacOS.sdk_path}/usr/include",
              "test.c", "-o", "testXC"
      assert_equal "Hello World!", shell_output("./testXC").chomp
    end

    # link against installed libc++
    # related to https://github.com/Homebrew/legacy-homebrew/issues/47149
    system "#{bin}/clang++", "-v", "-nostdinc",
            "-std=c++11", "-stdlib=libc++",
            "-I#{MacOS::Xcode.toolchain_path}/usr/include/c++/v1",
            "-I#{libclangxc}/include",
            "-I#{MacOS.sdk_path}/usr/include",
            "-L#{lib}",
            "-Wl,-rpath,#{lib}", "test.cpp", "-o", "test"
    assert_includes MachO::Tools.dylibs("test"), "#{opt_lib}/libc++.1.dylib"
    assert_equal "Hello World!", shell_output("./test").chomp
  end
end
