class Emscripten < Formula
  desc "LLVM bytecode to JavaScript compiler"
  homepage "https://emscripten.org/"
  url "https://github.com/emscripten-core/emscripten/archive/refs/tags/6.0.8.tar.gz"
  sha256 "959d29de4d685c4e1f85a304d58be7bb624f824187685e3660629feecffa5556"
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
    sha256 cellar: :any, arm64_tahoe:   "d1277c35185896c4dd31a54e6f807df9365abd092883fb5d1970c65097ed955f"
    sha256 cellar: :any, arm64_sequoia: "89607b39f8a8ab9bc978e3658c0e6d8c3cb851ff7494d042979e4c7685260fcd"
    sha256 cellar: :any, arm64_sonoma:  "aa3fbecbc386e45507464257a96609d5dd6119b02aa0cad4d117b777154f3355"
    sha256 cellar: :any, sonoma:        "ace1724e2bb1c3d60435b1d566a6906a7dda4ab9a1eca3df001f55f768f870f8"
    sha256 cellar: :any, arm64_linux:   "1bbaf2b27f7ff3806f703d8d75f911c8433efcb5ae51934b2d44c9cf606cfc4c"
    sha256 cellar: :any, x86_64_linux:  "1d976c9573bfa59053518c714f4957c74d2683632553da567ec14c7b7a82c406"
  end

  depends_on "cmake" => :build
  depends_on "node"
  depends_on "python@3.14"
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
    url "https://github.com/WebAssembly/binaryen/archive/8d546dc4aea1c3e81e77643f1ed0dea1a649d21d.tar.gz"
    version "8d546dc4aea1c3e81e77643f1ed0dea1a649d21d"
    sha256 "9fa0ad6d20c08115c861e5cab55d68d6d5abac35cdce95af9e1cb695065e005d"

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
    url "https://github.com/llvm/llvm-project/archive/c0125a7bf833b6cf0d5b4a085b63094e0893c85a.tar.gz"
    version "c0125a7bf833b6cf0d5b4a085b63094e0893c85a"
    sha256 "8c5672c92cd4cf3c0d50a8301ca9066e129ccb9e891e33478fd2acec2484055a"

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
    emscript_env = { PYTHON: which("python3.14") }
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
