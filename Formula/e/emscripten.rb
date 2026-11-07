class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https://emscripten.org/"
  url "https://github.com/emscripten-core/emscripten/archive/refs/tags/7.0.0.tar.gz"
  sha256 "5a4f436f6e28e669495173674a7bf0fc5e61c58b08fd3373e4e6242e01629cf4"
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
    sha256 cellar: :any, arm64_golden_gate: "ea3d5a7d623461bc4e5f00adf5a7b8f7575c01d9506804c93f82f969507edd7a"
    sha256 cellar: :any, arm64_tahoe:       "7dd5699db683b93261e89dfbe06c5cfa217b8237723608a348130d09e3e5c364"
    sha256 cellar: :any, arm64_sequoia:     "0c85112d0aabeabaac715185a5cce607ffccc20c977411e67d760dc3c1f319ad"
    sha256 cellar: :any, arm64_linux:       "8bc75ecc2eb0210621bbcb715778253c624c955694ec8f9664b9674abf712a69"
    sha256 cellar: :any, x86_64_linux:      "39450452fd3fe90d4d58a8186165c29e6d3ce56f4083747efcf6d536903c9935"
  end

  depends_on "cmake" => :build
  depends_on "node"
  depends_on "python@3.15"
  depends_on "yuicompressor"

  # OpenJDK is needed as a dependency on Linux and ARM64 for google-closure-compiler,
  # an emscripten dependency, because the native GraalVM image will not work.
  on_macos do
    on_arm do
      depends_on "openjdk"
    end
  end

  on_linux do
    depends_on "openjdk"
    depends_on "zlib-ng-compat"
  end

  # Use emscripten's recommended binaryen revision to avoid build failures.
  # https://github.com/emscripten-core/emscripten/issues/12252
  # To find the correct binaryen revision, find the corresponding version commit at:
  # https://github.com/emscripten-core/emsdk/blob/main/emscripten-releases-tags.json
  # Then take this commit and go to:
  # https://chromium.googlesource.com/emscripten-releases/+/<commit>/DEPS
  # Then use the listed binaryen_revision for the revision below.
  resource "binaryen" do
    url "https://github.com/WebAssembly/binaryen/archive/a9141c8ccdd082009c61970e715c02a8652a3f6f.tar.gz"
    version "a9141c8ccdd082009c61970e715c02a8652a3f6f"
    sha256 "16bd0846bb00e82ef5afada2f38c6c03c7527d747b6e142e1451827850232ef4"

    livecheck do
      url "https://raw.githubusercontent.com/emscripten-core/emsdk/refs/tags/#{LATEST_VERSION}/emscripten-releases-tags.json"
      regex(/["']binaryen_revision["']:\s*["']([0-9a-f]+)["']/i)
      strategy :json do |json, regex|
        # TODO: Find a way to replace `json.dig("aliases", "latest")` with substituted LATEST_VERSION
        release_hash = json.dig("releases", json.dig("aliases", "latest"))
        next if release_hash.blank?

        release_url = "https://chromium.googlesource.com/emscripten-releases/+/#{release_hash}/DEPS?format=TEXT"
        match = Homebrew::Livecheck::Strategy.page_content(release_url)[:content].unpack1("m").match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  # emscripten does not support using the stable version of LLVM.
  # https://github.com/emscripten-core/emscripten/issues/11362
  # See binaryen resource above for instructions on how to update this.
  # Then use the listed llvm_project_revision for the tarball below.
  resource "llvm" do
    url "https://github.com/llvm/llvm-project/archive/84ba7b37f02df5a5567e31a1bcfa0f607e578f12.tar.gz"
    version "84ba7b37f02df5a5567e31a1bcfa0f607e578f12"
    sha256 "06e15ba80099e543fdf07db3f96667320e623c33af19654fd30f409d50536a99"

    livecheck do
      url "https://raw.githubusercontent.com/emscripten-core/emsdk/refs/tags/#{LATEST_VERSION}/emscripten-releases-tags.json"
      regex(/["']llvm_project_revision["']:\s*["']([0-9a-f]+)["']/i)
      strategy :json do |json, regex|
        # TODO: Find a way to replace `json.dig("aliases", "latest")` with substituted LATEST_VERSION
        release_hash = json.dig("releases", json.dig("aliases", "latest"))
        next if release_hash.blank?

        release_url = "https://chromium.googlesource.com/emscripten-releases/+/#{release_hash}/DEPS?format=TEXT"
        match = Homebrew::Livecheck::Strategy.page_content(release_url)[:content].unpack1("m").match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  def install
    system "tools/maint/create_entry_points.py"

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
    rm_r(libexec/"test/third_party")

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
        -DLLVM_ENABLE_LZMA=OFF
        -DLLVM_ENABLE_Z3_SOLVER=OFF
        -DLLVM_INCLUDE_BENCHMARKS=OFF
      ]
      args << "-DLLVM_ENABLE_LIBEDIT=OFF" if OS.linux?

      system "cmake", "-S", "llvm", "-B", "build",
                      "-G", "Unix Makefiles",
                      *args, *std_cmake_args(install_prefix: libexec/"llvm")
      system "cmake", "--build", "build"
      system "cmake", "--build", "build", "--target", "install"

      # Remove unneeded tools. Taken from upstream `src/build.py`.
      unneeded = %w[
        check cl cpp extef-mapping format func-mapping import-test offload-bundler refactor rename
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
      system "cmake", "-S", ".", "-B", "build",
                      "-DBUILD_TESTS=OFF",
                      *std_cmake_args(install_prefix: libexec/"binaryen")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    cd libexec do
      system "npm", "install", *std_npm_args(prefix: false)
      # Delete native GraalVM image in incompatible platforms.
      if OS.linux? && Hardware::CPU.intel?
        rm_r("node_modules/google-closure-compiler-linux")
      elsif OS.linux? && Hardware::CPU.arm?
        rm_r("node_modules/google-closure-compiler-linux-arm64")
      elsif OS.mac? && Hardware::CPU.arm?
        rm_r("node_modules/google-closure-compiler-macos")
      end

      # Remove incompatible pre-built binaries
      os = OS.kernel_name.downcase
      arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
      rollup = libexec/"node_modules/@rollup"
      platform = OS.linux? ? "#{os}-#{arch}-gnu" : "#{os}-#{arch}"
      permitted_dir = "rollup-#{platform}"
      rollup.glob(rollup/"rollup-*").each do |dir|
        next if Dir.glob("#{dir}/rollup.*.node").empty?

        rm_r(dir) if permitted_dir != dir.basename.to_s
      end

      # Remove musl-libc native variants
      rm_r libexec/"node_modules/lightningcss-#{os}-#{arch}-musl" if OS.linux?
    end

    # Add JAVA_HOME to env_script on ARM64 macOS and Linux, so that google-closure-compiler
    # can find OpenJDK
    emscript_env = { EMSDK_PYTHON: python3 }
    emscript_env.merge! Language::Java.overridable_java_home_env if OS.linux? || Hardware::CPU.arm?

    emscripts.each do |emscript|
      (bin/emscript).write_env_script libexec/emscript, emscript_env
    end

    # Replace universal binaries with their native slices
    deuniversalize_machos libexec/"node_modules/fsevents/fsevents.node"

    (libexec/"post-install").write <<~SH
      #!/bin/sh
      set -e
      config="#{opt_libexec}/.emscripten"
      [ -e "$config" ] && exit 0
      if [ -e "$HOME/.emscripten" ]; then
        echo "Skipping configuration generation"
        echo "You have a ~/.emscripten configuration file. Remove it and run brew postinstall emscripten"
        exit 0
      fi
      "#{opt_bin}/emcc" --generate-config
      sed -E -i.bak \
        -e "s|^LLVM_ROOT[[:space:]]*[?+:!]?=.*$|LLVM_ROOT='#{opt_libexec}/llvm/bin'|" \
        -e "s|^BINARYEN_ROOT[[:space:]]*[?+:!]?=.*$|BINARYEN_ROOT='#{opt_libexec}/binaryen'|" \
        -e "s|^NODE_JS[[:space:]]*[?+:!]?=.*$|NODE_JS='#{formula_opt_bin("node")}/node'|" \
        "$config"
      rm -f "$config.bak"
    SH
    chmod 0755, libexec/"post-install"
  end

  post_install_steps do
    run "post-install", base: :libexec
  end

  test do
    ENV["EM_CACHE"] = testpath

    # We're targeting WASM, so we don't want to use the macOS SDK here.
    ENV.remove_macosxsdk if OS.mac?
    # Avoid errors on Linux when other formulae like `sdl12-compat` are installed
    ENV.delete "CPATH"

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main()
      {
        printf("Hello World!");
        return 0;
      }
    C

    system bin/"emcc", "test.c", "-o", "test.js", "-s", "NO_EXIT_RUNTIME=0", "-O2", "-Werror=version-check"
    assert_equal "Hello World!", shell_output("node test.js").chomp
  end
end
