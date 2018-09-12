class CodesignRequirement < Requirement
  fatal true

  satisfy(:build_env => false) do
    mktemp do
      FileUtils.cp "/usr/bin/false", "llvm_check"
      quiet_system "/usr/bin/codesign", "-f", "-s", "lldb_codesign", "--dryrun", "llvm_check"
    end
  end

  def message
    <<~EOS
      lldb_codesign identity must be available to build with LLDB.
      See: https://llvm.org/svn/llvm-project/lldb/trunk/docs/code-signing.txt
    EOS
  end
end

class Llvm < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"

  stable do
    url "https://releases.llvm.org/6.0.1/llvm-6.0.1.src.tar.xz"
    sha256 "b6d6c324f9c71494c0ccaf3dac1f16236d970002b42bb24a6c9e1634f7d0f4e2"

    resource "clang" do
      url "https://releases.llvm.org/6.0.1/cfe-6.0.1.src.tar.xz"
      sha256 "7c243f1485bddfdfedada3cd402ff4792ea82362ff91fbdac2dae67c6026b667"
    end

    resource "clang-extra-tools" do
      url "https://releases.llvm.org/6.0.1/clang-tools-extra-6.0.1.src.tar.xz"
      sha256 "0d2e3727786437574835b75135f9e36f861932a958d8547ced7e13ebdda115f1"
    end

    resource "compiler-rt" do
      url "https://releases.llvm.org/6.0.1/compiler-rt-6.0.1.src.tar.xz"
      sha256 "f4cd1e15e7d5cb708f9931d4844524e4904867240c306b06a4287b22ac1c99b9"
    end

    resource "libcxx" do
      url "https://releases.llvm.org/6.0.1/libcxx-6.0.1.src.tar.xz"
      sha256 "7654fbc810a03860e6f01a54c2297a0b9efb04c0b9aa0409251d9bdb3726fc67"
    end

    resource "libunwind" do
      url "https://releases.llvm.org/6.0.1/libunwind-6.0.1.src.tar.xz"
      sha256 "a8186c76a16298a0b7b051004d0162032b9b111b857fbd939d71b0930fd91b96"
    end

    resource "lld" do
      url "https://releases.llvm.org/6.0.1/lld-6.0.1.src.tar.xz"
      sha256 "e706745806921cea5c45700e13ebe16d834b5e3c0b7ad83bf6da1f28b0634e11"
    end

    resource "lldb" do
      url "https://releases.llvm.org/6.0.1/lldb-6.0.1.src.tar.xz"
      sha256 "6b8573841f2f7b60ffab9715c55dceff4f2a44e5a6d590ac189d20e8e7472714"
    end

    resource "openmp" do
      url "https://releases.llvm.org/6.0.1/openmp-6.0.1.src.tar.xz"
      sha256 "66afca2b308351b180136cf899a3b22865af1a775efaf74dc8a10c96d4721c5a"
    end

    resource "polly" do
      url "https://releases.llvm.org/6.0.1/polly-6.0.1.src.tar.xz"
      sha256 "e7765fdf6c8c102b9996dbb46e8b3abc41396032ae2315550610cf5a1ecf4ecc"
    end
  end

  bottle do
    root_url "https://homebrew.bintray.com/bottles"
    cellar :any
    rebuild 1
    sha256 "a1aa83b378bfe41b9795495095f9383629aefa4cdb1e9827f223b030c3d19b94" => :mojave
    sha256 "fa421bedb8bc2e4dd0dcb9d40c0d9c1f5d29b7f4364af3b03ec69e6a6a2fd228" => :high_sierra
    sha256 "3880d3191f26508516e3ae8059c71180dbf0a1bbbf4c471d8dc40d5e9217b55a" => :sierra
    sha256 "fef6a7a52d8a3e8a78b115b4ec09c366f0a54ec0f491e2df4d5d820ca9a01d1d" => :el_capitan
  end

  devel do
    url "https://prereleases.llvm.org/7.0.0/rc3/llvm-7.0.0rc3.src.tar.xz"
    sha256 "0adba9857ccf69d7456dba26961846986c9eca0befd3a519ea0c838872d64864"

    resource "clang" do
      url "https://prereleases.llvm.org/7.0.0/rc3/cfe-7.0.0rc3.src.tar.xz"
      sha256 "ec3258b3d0bb950e90db7f16c8542a34f9a7e2fe95cf20d178455c6a44bc4aa1"
    end

    resource "clang-extra-tools" do
      url "https://prereleases.llvm.org/7.0.0/rc3/clang-tools-extra-7.0.0rc3.src.tar.xz"
      sha256 "c71e69d615346561de5bfc168210cc1173e46289fe8ccef307a159f1c8a71b66"
    end

    resource "compiler-rt" do
      url "https://prereleases.llvm.org/7.0.0/rc3/compiler-rt-7.0.0rc3.src.tar.xz"
      sha256 "8108718f605b949dfa6c8c6d8c74089f2fbe5a287adcac08956d0213217a9064"
    end

    resource "libcxx" do
      url "https://prereleases.llvm.org/7.0.0/rc3/libcxx-7.0.0rc3.src.tar.xz"
      sha256 "e586c6bb071e568b2cc47af5f1ec0c31225f12cf0ea12a55d4691d1f9b469cfa"
    end

    resource "libunwind" do
      url "https://prereleases.llvm.org/7.0.0/rc3/libunwind-7.0.0rc3.src.tar.xz"
      sha256 "30fdee53d3c41b601239e2ec201a964fc86f70960df4a0d0d198f95386a0accd"
    end

    resource "lld" do
      url "https://prereleases.llvm.org/7.0.0/rc3/lld-7.0.0rc3.src.tar.xz"
      sha256 "2d16a09306238c319fedc020a3e13a463c78a633b21151f486a1eb3b23f6e882"
    end

    resource "lldb" do
      url "https://prereleases.llvm.org/7.0.0/rc3/lldb-7.0.0rc3.src.tar.xz"
      sha256 "f7d9d6141bd8880f0e3c2ddc70b08dbccdfe0777ba1269c752ebdb82b08a52e8"
    end

    resource "openmp" do
      url "https://prereleases.llvm.org/7.0.0/rc3/openmp-7.0.0rc3.src.tar.xz"
      sha256 "bc4d2d64838f8a311b9c4311911da71220acc789eb53fd5dcfa54258b0a411a5"
    end

    resource "polly" do
      url "https://prereleases.llvm.org/7.0.0/rc3/polly-7.0.0rc3.src.tar.xz"
      sha256 "09ec98ec96022489f41b547a48e8790fc6dd38a2a4c0682c8fc21df2c815f134"
    end
  end

  head do
    url "https://llvm.org/git/llvm.git"

    resource "clang" do
      url "https://llvm.org/git/clang.git"
    end

    resource "clang-extra-tools" do
      url "https://llvm.org/git/clang-tools-extra.git"
    end

    resource "compiler-rt" do
      url "https://llvm.org/git/compiler-rt.git"
    end

    resource "libcxx" do
      url "https://llvm.org/git/libcxx.git"
    end

    resource "libunwind" do
      url "https://llvm.org/git/libunwind.git"
    end

    resource "lld" do
      url "https://llvm.org/git/lld.git"
    end

    resource "lldb" do
      url "https://llvm.org/git/lldb.git"
    end

    resource "openmp" do
      url "https://llvm.org/git/openmp.git"
    end

    resource "polly" do
      url "https://llvm.org/git/polly.git"
    end
  end

  keg_only :provided_by_macos

  option "with-toolchain", "Build with Toolchain to facilitate overriding system compiler"
  option "with-lldb", "Build LLDB debugger"
  option "with-python@2", "Build bindings against Homebrew's Python 2"

  deprecated_option "with-python" => "with-python@2"

  # https://llvm.org/docs/GettingStarted.html#requirement
  depends_on "cmake" => :build
  depends_on "libffi"

  if MacOS.version <= :snow_leopard
    depends_on "python@2"
  else
    depends_on "python@2" => :optional
  end

  if build.with? "lldb"
    depends_on "swig" if MacOS.version >= :lion
    depends_on CodesignRequirement
  end

  # According to the official llvm readme, GCC 4.7+ is required
  fails_with :gcc_4_0
  fails_with :gcc
  ("4.3".."4.6").each do |n|
    fails_with :gcc => n
  end

  # Clang cannot find system headers if Xcode CLT is not installed
  pour_bottle? do
    reason "The bottle needs the Xcode CLT to be installed."
    satisfy { MacOS::CLT.installed? }
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
