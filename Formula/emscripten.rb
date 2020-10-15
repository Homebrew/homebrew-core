require "language/node"

class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https://emscripten.org/"
  url "https://github.com/emscripten-core/emscripten/archive/2.0.5.tar.gz"
  sha256 "35377ca91921c29b44d78a2de4c98a70b3eba31ae95d6ac843ea5cb361a857fc"
  # Emscripten is available under 2 licenses, the MIT license and the
  # University of Illinois/NCSA Open Source License.
  license "MIT"
  revision 1
  head "https://github.com/emscripten-core/emscripten.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "8a79e71f9300f585cd3f7ead55ff09cfe6e9b0d82325ce701b5e30cc267ccff8" => :catalina
    sha256 "0649ebcb7db1724a187bd30be0765ec83e101389cd90915d447244c43e75fb48" => :mojave
    sha256 "fcf60fa61a87cd545957314fed7c726575b2bda92421a9d696290eb09a471369" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "binaryen"
  depends_on "node"
  depends_on "python@3.9"
  depends_on "yuicompressor"

  # emscripten needs argument '-fignore-exceptions', which is only available
  # starting in llvm >= 12
  resource "llvm" do
    url "https://github.com/llvm/llvm-project/archive/llvmorg-12-init.tar.gz"
    sha256 "a8f00b95f81722009bdcc2cc07235fad752e5f539006621ad055023fe0d58987"
  end

  def install
    ENV.cxx11

    # All files from the repository are required as emscripten is a collection
    # of scripts which need to be installed in the same layout as in the Git
    # repository.
    libexec.install Dir["*"]

    resource("llvm").stage do
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

      llvmpath = Pathname.pwd/"llvm"

      # Apple's libstdc++ is too old to build LLVM
      ENV.libcxx if ENV.compiler == :clang

      # compiler-rt has some iOS simulator features that require i386 symbols
      # I'm assuming the rest of clang needs support too for 32-bit compilation
      # to work correctly, but if not, perhaps universal binaries could be
      # limited to compiler-rt. llvm makes this somewhat easier because compiler-rt
      # can almost be treated as an entirely different build from llvm.
      ENV.permit_arch_flags

      args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
        -DCMAKE_INSTALL_PREFIX=#{libexec}/llvm
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
        -DCLANG_INCLUDE_TESTS=OFF
      ]

      sdk = MacOS.sdk_path_if_needed
      args << "-DDEFAULT_SYSROOT=#{sdk}" if sdk

      if MacOS.version == :mojave && MacOS::CLT.installed?
        # Mojave CLT linker via software update is older than Xcode.
        # Use it to retain compatibility.
        args << "-DCMAKE_LINKER=/Library/Developer/CommandLineTools/usr/bin/ld"
      end

      mkdir llvmpath/"build" do
        system "cmake", "-G", "Unix Makefiles", "..", *args
        system "make"
        system "make", "install"
        system "make", "install-xcode-toolchain" if MacOS::Xcode.installed?
      end
    end

    cd libexec do
      system "npm", "install", *Language::Node.local_npm_install_args
      rm_f "node_modules/ws/builderror.log" # Avoid references to Homebrew shims
    end

    %w[em++ em-config emar emcc emcmake emconfigure emlink.py emmake
       emranlib emrun emscons].each do |emscript|
      (bin/emscript).write_env_script libexec/emscript, PYTHON: Formula["python@3.9"].opt_bin/"python3"
    end
  end

  def post_install
    system bin/"emcc"
    inreplace "#{libexec}/.emscripten" do |s|
      s.gsub! /^(LLVM_ROOT.*)/, "#\\1\nLLVM_ROOT = \"#{opt_libexec}/llvm/bin\"\\2"
      s.gsub! /^(BINARYEN_ROOT.*)/, "#\\1\nBINARYEN_ROOT = \"#{Formula["binaryen"].opt_prefix}\"\\2"
    end
  end

  test do
    # Fixes "Unsupported architecture" Xcode prepocessor error
    ENV.delete "CPATH"

    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        printf("Hello World!");
        return 0;
      }
    EOS

    system bin/"emcc", "test.c", "-o", "test.js", "-s", "NO_EXIT_RUNTIME=0"
    assert_equal "Hello World!", shell_output("node test.js").chomp
  end
end
