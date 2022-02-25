require "language/node"

class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https://emscripten.org/"
  url "https://github.com/emscripten-core/emscripten/archive/3.1.6.tar.gz"
  sha256 "84ee896bd14916ad1c9e0ade3f62b94fd2a2d8db34bd1f037bc99fe26d01f810"
  license all_of: [
    "Apache-2.0", # binaryen
    "Apache-2.0" => { with: "LLVM-exception" }, # llvm
    any_of: ["MIT", "NCSA"], # emscripten
  ]
  head "https://github.com/emscripten-core/emscripten.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8c6ea0c5cdaf27835db808671d0555958e949200de1d09c1d9b6217b00ca5033"
    sha256 cellar: :any,                 arm64_big_sur:  "4ed76d4e6499cb06250e6569eb2078f276062e79ecf0c730cd61e7fda23a34f5"
    sha256 cellar: :any,                 monterey:       "b0a8c57287fb03fae1a4aa66f7a000a58fcfbc153e21ec888a3a3827b6bbd932"
    sha256 cellar: :any,                 big_sur:        "281cde33d37afe219be813a05ba4587fab0a09687d9c84500f1d5f4b82779535"
    sha256 cellar: :any,                 catalina:       "8d7598a6151c8bc979712564ef94ec3dde8c16aeddc3a32fddb6d89bc6116aa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10976cf4606ec149b36aebedd87cdd8aaae4625800487436c621c9fb4f7a0138"
  end

  depends_on "cmake" => :build
  depends_on "node"
  depends_on "python@3.9"
  depends_on "yuicompressor"

  # OpenJDK is needed as a dependency on Linux and ARM64 for google-closure-compiler,
  # an emscripten dependency, because the native GraalVM image will not work.
  on_macos do
    depends_on "openjdk" if Hardware::CPU.arm?
  end

  on_linux do
    depends_on "gcc"
    depends_on "openjdk"
  end

  fails_with gcc: "5"

  # Use emscripten's recommended binaryen revision to avoid build failures.
  # See llvm resource below for instructions on how to update this.
  resource "binaryen" do
    url "https://github.com/WebAssembly/binaryen.git",
        revision: "11ada63fbb7ba982c92f22fa1fb0e39cebe3f194"
  end

  # emscripten needs argument '-fignore-exceptions', which is only available in llvm >= 12
  # To find the correct llvm revision, find a corresponding commit at:
  # https://github.com/emscripten-core/emsdk/blob/main/emscripten-releases-tags.json
  # Then take this commit and go to:
  # https://chromium.googlesource.com/emscripten-releases/+/<commit>/DEPS
  # Then use the listed llvm_project_revision for the resource below.
  resource "llvm" do
    url "https://github.com/llvm/llvm-project.git",
        revision: "6eec4835844439ab932515ff4ac857773c639171"
  end

  def install
    ENV.cxx11

    # All files from the repository are required as emscripten is a collection
    # of scripts which need to be installed in the same layout as in the Git
    # repository.
    libexec.install Dir["*"]

    # emscripten needs an llvm build with the following executables:
    # https://github.com/emscripten-core/emscripten/blob/#{version}/docs/packaging.md#dependencies
    resource("llvm").stage do
      projects = %w[
        clang
        lld
      ]

      targets = %w[
        host
        WebAssembly
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
        -DLLVM_TARGETS_TO_BUILD=#{targets.join(";")}
        -DLLVM_LINK_LLVM_DYLIB=ON
        -DLLVM_BUILD_LLVM_DYLIB=ON
        -DLLVM_INCLUDE_EXAMPLES=OFF
        -DLLVM_INCLUDE_TESTS=OFF
        -DLLVM_INSTALL_UTILS=OFF
      ]

      sdk = MacOS.sdk_path_if_needed
      args << "-DDEFAULT_SYSROOT=#{sdk}" if sdk

      if MacOS.version == :mojave && MacOS::CLT.installed?
        # Mojave CLT linker via software update is older than Xcode.
        # Use it to retain compatibility.
        args << "-DCMAKE_LINKER=/Library/Developer/CommandLineTools/usr/bin/ld"
      end

      mkdir llvmpath/"build" do
        # We can use `make` and `make install` here, but prefer these commands
        # for consistency with the llvm formula.
        system "cmake", "-G", "Unix Makefiles", "..", *args
        system "cmake", "--build", "."
        system "cmake", "--build", ".", "--target", "install"
      end
    end

    resource("binaryen").stage do
      args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
        -DCMAKE_INSTALL_PREFIX=#{libexec}/binaryen
      ]

      system "cmake", ".", *args
      system "make", "install"
    end

    cd libexec do
      system "npm", "install", *Language::Node.local_npm_install_args
      rm_f "node_modules/ws/builderror.log" # Avoid references to Homebrew shims
      # Delete native GraalVM image in incompatible platforms.
      if OS.linux?
        rm_rf "node_modules/google-closure-compiler-linux"
      elsif Hardware::CPU.arm?
        rm_rf "node_modules/google-closure-compiler-osx"
      end
    end

    # Add JAVA_HOME to env_script on ARM64 macOS and Linux, so that google-closure-compiler
    # can find OpenJDK
    emscript_env = { PYTHON: Formula["python@3.9"].opt_bin/"python3" }
    emscript_env.merge! Language::Java.overridable_java_home_env if OS.linux? || Hardware::CPU.arm?

    %w[em++ em-config emar emcc emcmake emconfigure emlink.py emmake
       emranlib emrun emscons].each do |emscript|
      (bin/emscript).write_env_script libexec/emscript, emscript_env
    end
  end

  def post_install
    system bin/"emcc", "--check"
    if File.exist?(libexec/".emscripten") && !File.exist?(libexec/".homebrew")
      touch libexec/".homebrew"
      inreplace "#{libexec}/.emscripten" do |s|
        s.gsub!(/^(LLVM_ROOT.*)/, "#\\1\nLLVM_ROOT = \"#{opt_libexec}/llvm/bin\"\\2")
        s.gsub!(/^(BINARYEN_ROOT.*)/, "#\\1\nBINARYEN_ROOT = \"#{opt_libexec}/binaryen\"\\2")
      end
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
