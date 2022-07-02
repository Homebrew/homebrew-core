require "language/node"

class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https://emscripten.org/"
  # TODO: Remove from versioned dependency conflict allowlist when `python`
  #       symlink is migrated to `python@3.10`.
  url "https://github.com/emscripten-core/emscripten/archive/3.1.15.tar.gz"
  sha256 "80946a6e03bf7f52777328d09c35cd3a50dcfe74a15a91470bd6469969c2a3e0"
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
    sha256 cellar: :any,                 arm64_monterey: "d7e4bb4ceb524adcf3ecc9a8654e15e648b04ca0773d71caa9e588e3136d956a"
    sha256 cellar: :any,                 arm64_big_sur:  "e137c5fadcf9d444c17373b233e4548c41c11abf356633660630cd0f0bf15bc2"
    sha256 cellar: :any,                 monterey:       "5060c67cd5fb5be0fd25b687094070d55fe4da08b8812cc093053d0f99d53bca"
    sha256 cellar: :any,                 big_sur:        "35412292d310dfee8456f178c021f3c5f2156a3db7fff6acce8e1bd3644ee4b7"
    sha256 cellar: :any,                 catalina:       "fa6cc845eafae8246ffdf2cb87f8c4638f28a43c8d9fd9e34044846a45d78d58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4857ec9669ea74bdde92a6e3b78b95907e7cb825c00eca6f1abe514cc21ea58f"
  end

  depends_on "cmake" => :build
  depends_on "node"
  depends_on "python@3.10"
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
        revision: "bab21052c3e12df7ad2fd3711d0fe6e69e05f449"
  end

  # emscripten needs argument '-fignore-exceptions', which is only available in llvm >= 12
  # To find the correct llvm revision, find a corresponding commit at:
  # https://github.com/emscripten-core/emsdk/blob/main/emscripten-releases-tags.json
  # Then take this commit and go to:
  # https://chromium.googlesource.com/emscripten-releases/+/<commit>/DEPS
  # Then use the listed llvm_project_revision for the resource below.
  resource "llvm" do
    url "https://github.com/llvm/llvm-project.git",
        revision: "7effcbda49ba32991b8955821b8fdbd4f8f303e2"
  end

  def install
    # Avoid hardcoding the executables we pass to `write_env_script` below.
    # Prefer executables without `.py` extensions, but include those with `.py`
    # extensions if there isn't a matching executable without the `.py` extension.
    emscripts = buildpath.children.select do |pn|
      next false unless pn.file?
      next false unless pn.executable?
      next false if pn.extname == ".py" && pn.basename(".py").exist?

      true
    end.map(&:basename)

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

      args = std_cmake_args(install_prefix: libexec/"llvm") + %W[
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

      mkdir llvmpath/"build" do
        # We can use `make` and `make install` here, but prefer these commands
        # for consistency with the llvm formula.
        system "cmake", "-G", "Unix Makefiles", "..", *args
        system "cmake", "--build", "."
        system "cmake", "--build", ".", "--target", "install"
      end
    end

    resource("binaryen").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: libexec/"binaryen")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
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
    emscript_env = { PYTHON: Formula["python@3.10"].opt_bin/"python3" }
    emscript_env.merge! Language::Java.overridable_java_home_env if OS.linux? || Hardware::CPU.arm?

    emscripts.each do |emscript|
      (bin/emscript).write_env_script libexec/emscript, emscript_env
    end
  end

  def post_install
    return if (libexec/".emscripten").exist?

    system bin/"emcc", "--generate-config"
    inreplace libexec/".emscripten" do |s|
      s.gsub!(/^(LLVM_ROOT.*)/, "#\\1\nLLVM_ROOT = \"#{libexec}/llvm/bin\"\\2")
      s.gsub!(/^(BINARYEN_ROOT.*)/, "#\\1\nBINARYEN_ROOT = \"#{libexec}/binaryen\"\\2")
    end
  end

  test do
    # Fixes "Unsupported architecture" Xcode prepocessor error
    ENV.delete "CPATH"

    ENV["NODE_OPTIONS"] = "--no-experimental-fetch"

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
