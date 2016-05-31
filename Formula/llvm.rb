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

  llvm_version = "3.8.0"

  stable do
    url "http://llvm.org/releases/#{llvm_version}/llvm-#{llvm_version}.src.tar.xz"
    sha256 "555b028e9ee0f6445ff8f949ea10e9cd8be0d084840e21fbbe1d31d51fc06e46"

    resource "clang" do
      url    "http://llvm.org/releases/#{llvm_version}/cfe-#{llvm_version}.src.tar.xz"
      sha256 "04149236de03cf05232d68eb7cb9c50f03062e339b68f4f8a03b650a11536cf9"
    end

    resource "clang-extra-tools" do
      url    "http://llvm.org/releases/#{llvm_version}/clang-tools-extra-#{llvm_version}.src.tar.xz"
      sha256 "afbda810106a6e64444bc164b921be928af46829117c95b996f2678ce4cb1ec4"
    end

    resource "compiler-rt" do
      url    "http://llvm.org/releases/#{llvm_version}/compiler-rt-#{llvm_version}.src.tar.xz"
      sha256 "c8d3387e55f229543dac1941769120f24dc50183150bf19d1b070d53d29d56b0"
    end

    # only required to build and run Compiler-RT tests on OS X, optional otherwise. clang.llvm.org/get_started.html
    resource "libcxx" do
      url    "http://llvm.org/releases/#{llvm_version}/libcxx-#{llvm_version}.src.tar.xz"
      sha256 "36804511b940bc8a7cefc7cb391a6b28f5e3f53f6372965642020db91174237b"
    end

    resource "libcxxabi" do
      url    "http://llvm.org/releases/#{llvm_version}/libcxxabi-#{llvm_version}.src.tar.xz"
      sha256 "c5ee0871aff6ec741380c4899007a7d97f0b791c81df69d25b744eebc5cee504"
    end

    resource "lld" do
      url "http://llvm.org/releases/#{llvm_version}/lld-#{llvm_version}.src.tar.xz"
      sha256 "94704dda228c9f75f4403051085001440b458501ec97192eee06e8e67f7f9f0c"
    end

    resource "lldb" do
      url "http://llvm.org/releases/#{llvm_version}/lldb-#{llvm_version}.src.tar.xz"
      sha256 "e3f68f44147df0433e7989bf6ed1c58ff28d7c68b9c47553cb9915f744785a35"
    end

    resource "openmp" do
      url "http://llvm.org/releases/#{llvm_version}/openmp-#{llvm_version}.src.tar.xz"
      sha256 "92510e3f62e3de955e3a0b6708cebee1ca344d92fb02369cba5fdd5c68f773a0"
    end

    resource "polly" do
      url "http://llvm.org/releases/#{llvm_version}/polly-#{llvm_version}.src.tar.xz"
      sha256 "84cbabc0b6a10a664797907d291b6955d5ea61aef04e3f3bb464e42374d1d1f2"
    end
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

    resource "libcxxabi" do
      url "http://llvm.org/git/libcxxabi.git"
    end

    resource "libunwind" do
      url "git://git.sv.gnu.org/libunwind.git"
    end

    resource "lld" do
      url "http://llvm.org/git/lld.git"
    end

    resource "lldb" do
      url "http://llvm.org/git/lldb.git"
    end

    resource "polly" do
      url "http://llvm.org/git/polly.git"
    end
  end

  keg_only :provided_by_osx

  # Options
  option :universal
  # option "with-clang",             "Build the Clang compiler and support libraries"
  option "without-clang",          "Do not build the Clang compiler and support libraries"
  option "with-clang-extra-tools", "Build extra tools for Clang"
  option "with-compiler-rt",       "Build Clang runtime support libraries for code sanitizers, builtins, and profiling"
  option "with-libcxx",            "Build the libc++ standard library"
  option "with-libcxxabi",         "Build the libc++abi standard library"
  option "with-libunwind",         "Build the libunwind library"
  option "with-lld",               "Build LLD linker"
  option "with-lldb",              "Build LLDB debugger"
  # option "with-rtti",              "Build with C++ RTTI"
  option "without-rtti",           "Do not build C++ RTTI"
  option "with-utils",             "Install utility binaries"
  option "with-polly",             "Build with the experimental Polly optimizer"
  option "with-python",            "Build Python bindings against Homebrew Python"
  option "with-test",              "Build LLVM unit tests"
  option "with-shared-libs",       "Build all libs as shared instead of static"
  option "with-libffi",            "Use libffi to call external functions from the interpreter"

  # Dependencies
  depends_on "cmake"    => :build

  depends_on "libffi"   => :optional # llvm.org/docs/GettingStarted.grml#requirements
  depends_on "doxygen"  => :optional # for C++ API reference (lldb)
  depends_on "graphviz" => :optional # for the 'dot' tool (lldb)
  depends_on "ocaml"    => :optional

  # Python
  if build.with?("python")
    depends_on "python"
  elsif MacOS.version <= :snow_leopard
    depends_on :python
  else
    depends_on :python => :optional # not sure this is correct
  end

  if build.with?("lldb")
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

  def install
    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    (buildpath/"tools/clang").install resource("clang") if build.with? "clang"

    if build.with? "clang-extra-tools"
      odie "--with-extra-tools requires --with-clang" if build.without? "clang"
      (buildpath/"tools/clang/tools/extra").install resource("clang-extra-tools")
    end

    (buildpath/"projects/libcxx").install    resource("libcxx")    if build.with? "libcxx"
    (buildpath/"projects/libcxxabi").install resource("libcxxabi") if build.with? "libcxxabi"
    (buildpath/"projects/libunwind").install resource("libunwind") if build.with? "libunwind"
    (buildpath/"tools/lld").install          resource("lld")       if build.with? "lld"

    if build.with? "lldb"
      odie "--with-lldb requires --with-clang" if build.without? "clang"
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

    if build.with? "polly"
      odie "--with-polly requires --with-clang" if build.without? "clang"
      (buildpath/"tools/polly").install resource("polly")
    end

    if build.with? "compiler-rt"
      odie "--with-compiler-rt requires --with-clang" if build.without? "clang"
      (buildpath/"projects/compiler-rt").install resource("compiler-rt")

      # compiler-rt has some iOS simulator features that require i386 symbols
      # I'm assuming the rest of clang needs support too for 32-bit compilation
      # to work correctly, but if not, perhaps universal binaries could be
      # limited to compiler-rt. llvm makes this somewhat easier because compiler-rt
      # can almost be treated as an entirely different build from llvm.
      ENV.permit_arch_flags
    end

    args = %w[
      -DLLVM_OPTIMIZED_TABLEGEN=On
      -DLLVM_BUILD_LLVM_DYLIB=On
      -DLLVM_TARGETS_TO_BUILD=X86
    ]

    args << "-DLLVM_BUILD_EXTERNAL_COMPILER_RT=On" if build.with? "compiler-rt"
    if build.with? "test"
      args << "-DLLVM_BUILD_TESTS=On"
      args << "-DLLVM_ABI_BREAKING_CHECKS=On"
    end
    args << "-DLLVM_ENABLE_RTTI=On"      if build.with? "rtti"
    args << "-DLLVM_INSTALL_UTILS=On"    if build.with? "utils"
    args << "-DLLVM_ENABLE_LIBCXX=On"    if build.with? "libcxx"
    args << "-DLLVM_ENABLE_LIBCXXABI=On" if build.with? "libcxxabi"
    args << "-DLLVM_ENABLE_DOXYGEN=On"   if build.with? "doxygen"
    args << "-DBUILD_SHARED_LIBS=On"     if build.with? "shared-libs" # for developers

    if build.with? "libffi"
      args << "-DLLVM_ENABLE_FFI=On"
      args << "-DFFI_INCLUDE_DIR=#{Formula["libffi"].lib}/libffi-#{Formula["libffi"].version}/include" # upstream bug?
      args << "-DFFI_LIBRARY_DIR=#{Formula["libffi"].lib}"
    end

    if build.universal?
      ENV.permit_arch_flags
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    if build.with? "polly"
      args << "-DWITH_POLLY=On"
      args << "-DLINK_POLLY_INTO_TOOLS=On"
    end

    mktemp do
      system "cmake", "-G", "Unix Makefiles", buildpath, *(std_cmake_args + args)
      system "make"
      system "make", "install"
    end

    if build.with? "clang"
      (share/"clang/tools").install Dir["tools/clang/tools/scan-{build,view}"]
      if build.head?
        # inreplace "#{share}/clang/tools/scan-build/bin/scan-build", "$RealBin/bin/clang", "#{bin}/clang"
        bin.install_symlink share/"clang/tools/scan-build/bin/scan-build", share/"clang/tools/scan-view/bin/scan-view"
        man1.install_symlink share/"clang/tools/scan-build/man/scan-build.1"
      else
        # inreplace "#{share}/clang/tools/scan-build/scan-build", "$RealBin/bin/clang", "#{bin}/clang"
        bin.install_symlink share/"clang/tools/scan-build/scan-build", share/"clang/tools/scan-view/scan-view"
        man1.install_symlink share/"clang/tools/scan-build/scan-build.1"
      end
    end

    # install llvm python bindings
    (lib/"python2.7/site-packages").install buildpath/"bindings/python/llvm"
    (lib/"python2.7/site-packages").install buildpath/"tools/clang/bindings/python/clang" if build.with? "clang"
  end

  def caveats
    s = <<-EOS.undent
      LLVM executables are installed in #{opt_bin}.
    Extra tools are installed in #{opt_share}/llvm.
    EOS

    if build.with? "libcxx"
      s += <<-EOS.undent
        To use the bundled libc++ please add the following LDFLAGS:
          LDFLAGS="-L#{opt_lib} -lc++"
      EOS
    end

    s
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/llvm-config --prefix").chomp

    if build.with? "clang"
      (testpath/"test.cpp").write <<-EOS.undent
        #include <iostream>
        using namespace std;

        int main()
        {
          cout << "Hello World!" << endl;
          return 0;
        }
      EOS
      system "#{bin}/clang++", "test.cpp", "-o", "test"
      system "./test"
    end
  end
end
