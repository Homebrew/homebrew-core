require "language/node"

class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https://emscripten.org/"
  url "https://github.com/emscripten-core/emscripten/archive/refs/tags/3.1.53.tar.gz"
  sha256 "1615542b0e89809047b7d5017f29388a0ca4e93a2489f915f956b42db683a0d8"
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
    sha256 cellar: :any,                 arm64_sonoma:   "fee49cb809413962b75643a90be3955cb1baa24997fb5f24bc9bd3e29678b6d0"
    sha256 cellar: :any,                 arm64_ventura:  "21f05ea701ed41e0d34a5826ac380d6ee9bf6e524e38f59e1814b9347018b901"
    sha256 cellar: :any,                 arm64_monterey: "9e96d075260c69713283754209496a434bc252f096cbc653c1be9fd9cff091c6"
    sha256 cellar: :any,                 sonoma:         "e919c8d15ff3d84992b867c0c0ca48057c2285d6ea2ec69523127d2c9fe45c80"
    sha256 cellar: :any,                 ventura:        "6575770c907ffe9a34eea5ee9e2c631e7c1372cc0f449de192a8e90723d2c884"
    sha256 cellar: :any,                 monterey:       "c1c3a02aa1deebb0ead2c25822173a7e7de12582703084da64952d9f228b2d0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e28e1e6ae5791a8e4e4bb52079a6d5535f6b54fab6c6aba54f592e74aea3039"
  end

  depends_on "cmake" => :build
  depends_on "node"
  depends_on "python@3.12"
  depends_on "yuicompressor"

  uses_from_macos "zlib"

  # OpenJDK is needed as a dependency on Linux and ARM64 for google-closure-compiler,
  # an emscripten dependency, because the native GraalVM image will not work.
  on_macos do
    on_arm do
      depends_on "openjdk"
    end
  end

  on_linux do
    depends_on "openjdk"
  end

  fails_with gcc: "5"

  # Use emscripten's recommended binaryen revision to avoid build failures.
  # https://github.com/emscripten-core/emscripten/issues/12252
  # To find the correct binaryen revision, find the corresponding version commit at:
  # https://github.com/emscripten-core/emsdk/blob/main/emscripten-releases-tags.json
  # Then take this commit and go to:
  # https://chromium.googlesource.com/emscripten-releases/+/<commit>/DEPS
  # Then use the listed binaryen_revision for the revision below.
  resource "binaryen" do
    url "https://github.com/WebAssembly/binaryen.git",
        revision: "9e636855b582d1499a87fb73f55d85102ce95a58"
  end

  # emscripten does not support using the stable version of LLVM.
  # https://github.com/emscripten-core/emscripten/issues/11362
  # See binaryen resource above for instructions on how to update this.
  # Then use the listed llvm_project_revision for the tarball below.
  resource "llvm" do
    url "https://github.com/llvm/llvm-project/archive/f2464ca317bfeeedddb7cbdea3c2c8ec487890bb.tar.gz"
    sha256 "a73110a2bd7d2c31c9f021780cb5c60855dc5dffb1ee15e2932aeeb2c67d6f0b"
  end

  def install
    # Avoid hardcoding the executables we pass to `write_env_script` below.
    # Prefer executables without `.py` extensions, but include those with `.py`
    # extensions if there isn't a matching executable without the `.py` extension.
    emscripts = buildpath.children.select do |pn|
      pn.file? && pn.executable? && !(pn.extname == ".py" && pn.basename(".py").exist?)
    end.map(&:basename)

    # All files from the repository are required as emscripten is a collection
    # of scripts which need to be installed in the same layout as in the Git
    # repository.
    libexec.install buildpath.children

    # Remove unneeded files. See `tools/install.py`.
    (libexec/"test/third_party").rmtree

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

      # Apple's libstdc++ is too old to build LLVM
      ENV.libcxx if ENV.compiler == :clang

      # See upstream configuration in `src/build.py` at
      # https://chromium.googlesource.com/emscripten-releases/
      args = %W[
        -DLLVM_ENABLE_LIBXML2=OFF
        -DLLVM_INCLUDE_EXAMPLES=OFF
        -DLLVM_LINK_LLVM_DYLIB=OFF
        -DLLVM_BUILD_LLVM_DYLIB=OFF
        -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
        -DLLVM_ENABLE_BINDINGS=OFF
        -DLLVM_TOOL_LTO_BUILD=OFF
        -DLLVM_INSTALL_TOOLCHAIN_ONLY=ON
        -DLLVM_TARGETS_TO_BUILD=#{targets.join(";")}
        -DLLVM_ENABLE_PROJECTS=#{projects.join(";")}
        -DLLVM_ENABLE_TERMINFO=#{!OS.linux?}
        -DCLANG_ENABLE_ARCMT=OFF
        -DCLANG_ENABLE_STATIC_ANALYZER=OFF
        -DLLVM_INCLUDE_TESTS=OFF
        -DLLVM_INSTALL_UTILS=OFF
        -DLLVM_ENABLE_ZSTD=OFF
        -DLLVM_ENABLE_Z3_SOLVER=OFF
      ]
      args << "-DLLVM_ENABLE_LIBEDIT=OFF" if OS.linux?

      system "cmake", "-S", "llvm", "-B", "build",
                      "-G", "Unix Makefiles",
                      *args, *std_cmake_args(install_prefix: libexec/"llvm")
      system "cmake", "--build", "build"
      system "cmake", "--build", "build", "--target", "install"

      # Remove unneeded tools. Taken from upstream `src/build.py`.
      unneeded = %w[
        check cl cpp extef-mapping format func-mapping import-test offload-bundler refactor rename scan-deps
      ].map { |suffix| "clang-#{suffix}" }
      unneeded += %w[lld-link ld.lld ld64.lld llvm-lib ld64.lld.darwinnew ld64.lld.darwinold]
      (libexec/"llvm/bin").glob("{#{unneeded.join(",")}}").map(&:unlink)
      (libexec/"llvm/lib").glob("libclang.{dylib,so.*}").map(&:unlink)

      # Include needed tools omitted by `LLVM_INSTALL_TOOLCHAIN_ONLY`.
      # Taken from upstream `src/build.py`.
      extra_tools = %w[FileCheck llc llvm-as llvm-dis llvm-link llvm-mc
                       llvm-nm llvm-objdump llvm-readobj llvm-size opt
                       llvm-dwarfdump llvm-dwp]
      (libexec/"llvm/bin").install extra_tools.map { |tool| "build/bin/#{tool}" }

      %w[clang clang++].each do |compiler|
        (libexec/"llvm/bin").install_symlink compiler => "wasm32-#{compiler}"
        (libexec/"llvm/bin").install_symlink compiler => "wasm32-wasi-#{compiler}"
        bin.install_symlink libexec/"llvm/bin/wasm32-#{compiler}"
        bin.install_symlink libexec/"llvm/bin/wasm32-wasi-#{compiler}"
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
    emscript_env = { PYTHON: Formula["python@3.12"].opt_bin/"python3.12" }
    emscript_env.merge! Language::Java.overridable_java_home_env if OS.linux? || Hardware::CPU.arm?

    emscripts.each do |emscript|
      (bin/emscript).write_env_script libexec/emscript, emscript_env
    end

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"node_modules/fsevents/fsevents.node"
  end

  def post_install
    return if File.exist?("#{Dir.home}/.emscripten")
    return if (libexec/".emscripten").exist?

    system bin/"emcc", "--generate-config"
    inreplace libexec/".emscripten" do |s|
      s.change_make_var! "LLVM_ROOT", "'#{libexec}/llvm/bin'"
      s.change_make_var! "BINARYEN_ROOT", "'#{libexec}/binaryen'"
      s.change_make_var! "NODE_JS", "'#{Formula["node"].opt_bin}/node'"
      s.change_make_var! "JAVA", "'#{Formula["openjdk"].opt_bin}/java'"
    end
  end

  def caveats
    return unless File.exist?("#{Dir.home}/.emscripten")
    return if (libexec/".emscripten").exist?

    <<~EOS
      You have a ~/.emscripten configuration file, so the default configuration
      file was not generated. To generate the default configuration:
        rm ~/.emscripten
        brew postinstall emscripten
    EOS
  end

  test do
    # We're targeting WASM, so we don't want to use the macOS SDK here.
    ENV.remove_macosxsdk if OS.mac?
    # Avoid errors on Linux when other formulae like `sdl12-compat` are installed
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
