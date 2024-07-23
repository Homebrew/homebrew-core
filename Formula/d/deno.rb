class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.com/"
  url "https://github.com/denoland/deno/releases/download/v1.45.3/deno_src.tar.gz"
  sha256 "957447a341f5e93aa1af674bb9d5be8264fe863c323291d84a81cd4f9edd3f1f"
  license "MIT"
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ed302dd5236c54de0b45baa670d286bf07b52d353fd94ac034840acfa06880d9"
    sha256 cellar: :any,                 arm64_ventura:  "3d462da607d3a9017dd196b63ef75f0a8fef6d9c7c9d07c119bb062d381c4799"
    sha256 cellar: :any,                 arm64_monterey: "49f935351e6db683d090b72bff004f925e054f98850006d5cb59c1eb50d48660"
    sha256 cellar: :any,                 sonoma:         "443c69ac0932260fac8f9462f9cb4ba6a2c0f72f0189e4bd6337174d6833ed45"
    sha256 cellar: :any,                 ventura:        "3159a53da7455984031a3e270b00d626127ae5efb068c7d5caade07fb4467927"
    sha256 cellar: :any,                 monterey:       "5fefd803e136185abfce579731995792adffbc6297a4ed0aacfe44127ac3bcb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "222b777fc0d7f306c0fa1a93e2f82bf10c45348421b6488e519e4546b0e53a4b"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "sqlite" # needs `sqlite3_unlock_notify`

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "libffi"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_macos do
    depends_on xcode: ["10.0", :build] # required by v8 7.9+
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "glib"
  end

  fails_with gcc: "5"

  # Temporary resources to work around build failure due to files missing from crate
  # We use the crate as GitHub tarball lacks submodules and this allows us to avoid git overhead.
  # TODO: Remove this and `v8` resource when https://github.com/denoland/rusty_v8/issues/1065 is resolved
  # VERSION=#{version} && curl -s https://raw.githubusercontent.com/denoland/deno/v$VERSION/Cargo.lock | grep -C 1 'name = "v8"'
  resource "rusty_v8" do
    url "https://static.crates.io/crates/v8/v8-0.98.0.crate"
    sha256 "feb252d5be11c32cb4755d66d58db30ff30af5f1f17183e83ff54383a402c5f6"
  end

  # Find the v8 version from the last commit message at:
  # https://github.com/denoland/rusty_v8/commits/v#{rusty_v8_version}/v8
  # Then, use the corresponding tag found in https://github.com/denoland/v8/tags
  resource "v8" do
    url "https://github.com/denoland/v8/archive/refs/tags/12.7.224.13-denoland-14a82560ca2be2d55ecc.tar.gz"
    sha256 "f902a5fe9320ed6c03004b43d15387d1a2e8c727d7042ed29875a49837fc91e2"
  end

  # VERSION=#{version} && curl -s https://raw.githubusercontent.com/denoland/deno/v$VERSION/Cargo.lock | grep -C 1 'name = "deno_core"'
  resource "deno_core" do
    url "https://github.com/denoland/deno_core/archive/refs/tags/0.294.0.tar.gz"
    sha256 "ade7fe83bd830b632023877d6ae3db63437c4763e3ab9f9e08f7ae9e40d1a32b"
  end

  # To find the version of gn used:
  # 1. Update the version for resource `rusty_v8` (see comment above).
  # 2. Find ninja_gn_binaries tag: https://github.com/denoland/rusty_v8/blob/v#{rusty_v8_version}/tools/ninja_gn_binaries.py#L21
  # 3. Find short gn commit hash from commit message: https://github.com/denoland/ninja_gn_binaries/tree/#{ninja_gn_binaries_tag}
  # 4. Find full gn commit hash: https://gn.googlesource.com/gn.git/+/#{gn_commit}
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "70d6c60823c0233a0f35eccc25b2b640d2980bdc"
  end

  def install
    # Work around files missing from crate
    # TODO: Remove this at the same time as `rusty_v8` + `v8` resources
    resource("rusty_v8").stage buildpath/"../rusty_v8"
    resource("v8").stage do
      cp_r "tools/builtins-pgo", buildpath/"../rusty_v8/v8/tools/builtins-pgo"
    end

    resource("deno_core").stage buildpath/"../deno_core"

    # Avoid vendored dependencies.
    inreplace "ext/ffi/Cargo.toml",
              /^libffi-sys = "(.+)"$/,
              'libffi-sys = { version = "\\1", features = ["system"] }'
    inreplace "Cargo.toml",
              /^rusqlite = { version = "(.+)", features = \["unlock_notify", "bundled"\] }$/,
              'rusqlite = { version = "\\1", features = ["unlock_notify"] }'

    if OS.mac? && (MacOS.version < :mojave)
      # Overwrite Chromium minimum SDK version of 10.15
      ENV["FORCE_MAC_SDK_MIN"] = MacOS.version
    end

    python3 = which("python3")
    # env args for building a release build with our python3, ninja and gn
    ENV["PYTHON"] = python3
    ENV["GN"] = buildpath/"gn/out/gn"
    ENV["NINJA"] = Formula["ninja"].opt_bin/"ninja"
    # build rusty_v8 from source
    ENV["V8_FROM_SOURCE"] = "1"
    # Build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = Formula["llvm"].prefix

    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    resource("gn").stage buildpath/"gn"
    cd "gn" do
      system python3, "build/gen.py"
      system "ninja", "-C", "out"
    end

    # cargo seems to build rusty_v8 twice in parallel, which causes problems,
    # hence the need for -j1
    # Issue ref: https://github.com/denoland/deno/issues/9244
    system "cargo", "--config", ".cargo/local-build.toml",
                    "install", "--no-default-features", "-vv", "-j1",
                    *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"deno", "completions")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    IO.popen("deno run -A -r https://fresh.deno.dev fresh-project", "r+") do |pipe|
      pipe.puts "n"
      pipe.puts "n"
      pipe.close_write
      pipe.read
    end

    assert_match "# Fresh project", (testpath/"fresh-project/README.md").read

    (testpath/"hello.ts").write <<~EOS
      console.log("hello", "deno");
    EOS
    assert_match "hello deno", shell_output("#{bin}/deno run hello.ts")
    assert_match "Welcome to Deno!",
      shell_output("#{bin}/deno run https://deno.land/std@0.100.0/examples/welcome.ts")

    linked_libraries = [
      Formula["sqlite"].opt_lib/shared_library("libsqlite3"),
    ]
    unless OS.mac?
      linked_libraries += [
        Formula["libffi"].opt_lib/shared_library("libffi"),
        Formula["zlib"].opt_lib/shared_library("libz"),
      ]
    end
    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"deno", library),
              "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
