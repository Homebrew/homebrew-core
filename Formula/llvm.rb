class Llvm < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"

  stable do
    url "https://releases.llvm.org/7.0.1/llvm-7.0.1.src.tar.xz"
    sha256 "a38dfc4db47102ec79dcc2aa61e93722c5f6f06f0a961073bd84b78fb949419b"

    resource "clang" do
      url "https://releases.llvm.org/7.0.1/cfe-7.0.1.src.tar.xz"
      sha256 "a45b62dde5d7d5fdcdfa876b0af92f164d434b06e9e89b5d0b1cbc65dfe3f418"
    end

    resource "clang-extra-tools" do
      url "https://releases.llvm.org/7.0.1/clang-tools-extra-7.0.1.src.tar.xz"
      sha256 "4c93c7d2bb07923a8b272da3ef7914438080aeb693725f4fc5c19cd0e2613bed"
    end

    resource "compiler-rt" do
      url "https://releases.llvm.org/7.0.1/compiler-rt-7.0.1.src.tar.xz"
      sha256 "782edfc119ee172f169c91dd79f2c964fb6b248bd9b73523149030ed505bbe18"
    end

    resource "libcxx" do
      url "https://releases.llvm.org/7.0.1/libcxx-7.0.1.src.tar.xz"
      sha256 "020002618b319dc2a8ba1f2cba88b8cc6a209005ed8ad29f9de0c562c6ebb9f1"
    end

    resource "libunwind" do
      url "https://releases.llvm.org/7.0.1/libunwind-7.0.1.src.tar.xz"
      sha256 "89c852991dfd9279dbca9d5ac10b53c67ad7d0f54bbab7156e9f057a978b5912"
    end

    resource "lld" do
      url "https://releases.llvm.org/7.0.1/lld-7.0.1.src.tar.xz"
      sha256 "8869aab2dd2d8e00d69943352d3166d159d7eae2615f66a684f4a0999fc74031"
    end

    resource "lldb" do
      url "https://releases.llvm.org/7.0.1/lldb-7.0.1.src.tar.xz"
      sha256 "76b46be75b412a3d22f0d26279306ae7e274fe4d7988a2184c529c38a6a76982"
    end

    resource "openmp" do
      url "https://releases.llvm.org/7.0.1/openmp-7.0.1.src.tar.xz"
      sha256 "bf16b78a678da67d68405214ec7ee59d86a15f599855806192a75dcfca9b0d0c"
    end

    resource "polly" do
      url "https://releases.llvm.org/7.0.1/polly-7.0.1.src.tar.xz"
      sha256 "1bf146842a09336b9c88d2d76c2d117484e5fad78786821718653d1a9d57fb71"
    end
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "75f543117d0a1284dddd9024019999244eeedb868dc994b3f678649a7f1fa4d0" => :mojave
    sha256 "e3db8b310f9e682252c903560c00ed75b49f4e20414b41be4f2ebb95b761c4d3" => :high_sierra
    sha256 "2a6a2dd761c8ceaf27b87e03bdf890a6253b7cfa9ff3f241ef83913701b7dfab" => :sierra
  end

  # Clang cannot find system headers if Xcode CLT is not installed
  pour_bottle? do
    reason "The bottle needs the Xcode CLT to be installed."
    satisfy { MacOS::CLT.installed? }
  end

  head do
    url "https://git.llvm.org/git/llvm.git"

    resource "clang" do
      url "https://git.llvm.org/git/clang.git"
    end

    resource "clang-extra-tools" do
      url "https://git.llvm.org/git/clang-tools-extra.git"
    end

    resource "compiler-rt" do
      url "https://git.llvm.org/git/compiler-rt.git"
    end

    resource "libcxx" do
      url "https://git.llvm.org/git/libcxx.git"
    end

    resource "libunwind" do
      url "https://git.llvm.org/git/libunwind.git"
    end

    resource "lld" do
      url "https://git.llvm.org/git/lld.git"
    end

    resource "lldb" do
      url "https://git.llvm.org/git/lldb.git"
    end

    resource "openmp" do
      url "https://git.llvm.org/git/openmp.git"
    end

    resource "polly" do
      url "https://git.llvm.org/git/polly.git"
    end
  end

  keg_only :provided_by_macos

  option "with-lldb", "Build LLDB debugger"

  # https://llvm.org/docs/GettingStarted.html#requirement
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "libffi"

  depends_on "python@2" if MacOS.version <= :snow_leopard

  if build.with? "lldb"
    depends_on "swig" if MacOS.version >= :lion
    depends_on :codesign => [{
      :identity => "lldb_codesign",
      :with     => "LLDB",
      :url      => "https://llvm.org/svn/llvm-project/lldb/trunk/docs/code-signing.txt",
    }]
  end

  # According to the official llvm readme, GCC 4.7+ is required
  fails_with :gcc_4_0
  fails_with :gcc_4_2
  ("4.3".."4.6").each do |n|
    fails_with :gcc => n
  end

  def install
    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    (buildpath/"tools/clang").install resource("clang")
    (buildpath/"tools/clang/tools/extra").install resource("clang-extra-tools")
    (buildpath/"projects/openmp").install resource("openmp")
    (buildpath/"projects/libcxx").install resource("libcxx")
    (buildpath/"projects/libunwind").install resource("libunwind")
    (buildpath/"tools/lld").install resource("lld")
    (buildpath/"tools/polly").install resource("polly")

    if build.with? "lldb"
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
      -DLLVM_CREATE_XCODE_TOOLCHAIN=ON
    ]

    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *(std_cmake_args + args)
      system "ninja"
      system "ninja", "install"
      system "ninja", "install-xcode-toolchain"
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
