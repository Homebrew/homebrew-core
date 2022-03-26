require "language/node"

class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https://emscripten.org/"
  # TODO: Remove from versioned dependency conflict allowlist when `python`
  #       symlink is migrated to `python@3.10`.
  url "https://github.com/emscripten-core/emscripten/archive/3.1.8.tar.gz"
  sha256 "9ffe1fb3a816b1de3050f990a10519b72349451200947f019aaf26728f40604c"
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
    sha256 cellar: :any,                 arm64_monterey: "3108e8c1706cbd0ff8f6afca11e1a52db027f2c53fd558bfc24008a601e100ec"
    sha256 cellar: :any,                 arm64_big_sur:  "efb92eb0a7f49a7ef27485849e1c33098591ca58feb0cb97e73aa77c22b8d68b"
    sha256 cellar: :any,                 monterey:       "ec6afef9c3ae653133c271bdc494d441091936b0c671779e4b7d1fceffb1e89c"
    sha256 cellar: :any,                 big_sur:        "7f15af192fdb46532b5a250691b0a6e639de046288ad46229293b9b425539a98"
    sha256 cellar: :any,                 catalina:       "cbc77b1616f16a4de83ae094f9ad7288267ee3e16349fee30cc4e547fcdcc755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0109b938316341dd5b1299d2327cb6782b9e3ae76563831a4a04233118a29a44"
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
        revision: "22d24fda983d471ebf73ebadbc37ef1741a5594d"
  end

  # emscripten needs argument '-fignore-exceptions', which is only available in llvm >= 12
  # To find the correct llvm revision, find a corresponding commit at:
  # https://github.com/emscripten-core/emsdk/blob/main/emscripten-releases-tags.json
  # Then take this commit and go to:
  # https://chromium.googlesource.com/emscripten-releases/+/<commit>/DEPS
  # Then use the listed llvm_project_revision for the resource below.
  resource "llvm" do
    url "https://github.com/llvm/llvm-project.git",
        revision: "80ec0ebfdc5692a58e0832125f2c6a991df9d63f"
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
