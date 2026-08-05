class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.com/"
  url "https://github.com/denoland/deno/releases/download/v2.9.4/deno_src.tar.gz"
  sha256 "95f9d8361809f2d2f3ee2d8a6955951dcf96c2f4bbeb540c2d6fdd9363e6dc94"
  license "MIT"
  compatibility_version 1
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a9ed230d6c51f90a9ea475257da3a08ec9d4016cda041caeda272b4c80e01ee6"
    sha256 cellar: :any, arm64_sequoia: "c9d76eed9eb7ce3a3c1ac9376810fb6e0416870a6ce1efdde2cf8c7b899e0bd6"
    sha256 cellar: :any, arm64_sonoma:  "4e9cf92a7196f53795cc514bbed57f509b8a5530d852b3b54197f4cb8ba0a2ea"
    sha256 cellar: :any, sonoma:        "ded605266a70ca35573704679e81ad102e320518dc7b4c86afa693a3d75ef114"
    sha256 cellar: :any, arm64_linux:   "c1d990de7d8db190baafe2b11b7f2fe6bf19be1c172d9afebc5594be8cb0d6fa"
    sha256 cellar: :any, x86_64_linux:  "2aaccad7608d4a6ae08592cd288da3a9198f22c03186a65805bd66ce09b498e5"
  end

  depends_on "cmake" => :build
  depends_on "lld" => :build
  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on xcode: ["15.0", :build] # v8 12.9+ uses linker flags introduced in xcode 15
  depends_on "little-cms2"
  depends_on "sqlite" # needs `sqlite3_unlock_notify`

  uses_from_macos "python" => :build
  uses_from_macos "libffi"

  on_linux do
    depends_on "glib" => :build
    depends_on "pcre2" => :build
    depends_on "zlib-ng-compat"
  end

  conflicts_with "dxpy", because: "both install `dx` binaries"

  # Temporary resource to work around build failure due to files missing from
  # crate needed to build with V8_FROM_SOURCE=1
  resource "rusty_v8" do
    url "https://github.com/denoland/rusty_v8.git",
        tag:      "v150.2.0",
        revision: "d305e6afa7736f6e298c30ae6646f7709ee9382b"

    livecheck do
      url "https://raw.githubusercontent.com/denoland/deno/refs/tags/v#{LATEST_VERSION}/Cargo.lock"
      regex(/^name = "v8"\nversion = "(\d+(?:\.\d+)+)"/i)
    end
  end

  def llvm = Formula["llvm"]

  def install
    # Work around files missing from crate
    resource("rusty_v8").stage("rusty_v8")
    if build.head? && (v8_version = File.read("Cargo.lock")[/^name = "v8"\nversion = "(\d+(?:\.\d+)+)"/i, 1])
      system "git", "-C", "rusty_v8", "checkout", "--recurse-submodules", "v#{v8_version}"
    end
    args = %w[--config patch.crates-io.v8.path="rusty_v8"]

    # Same inreplaces as `v8` formula to allow building with stable Clang
    inreplace "rusty_v8/build/config/compiler/BUILD.gn" do |s|
      s.gsub! 'cflags += [ "-fno-lifetime-dse" ]', ""
      s.gsub! 'cflags += [ "-fdiagnostics-show-inlining-chain" ]', ""
    end
    inreplace "rusty_v8/build/config/sanitizers/sanitizers.gni",
              '"-fsanitize-ignore-for-ubsan-feature=${invoker.sanitizer}",', ""

    # FIXME: unable to build with brew rust (via `rust_sysroot_absolute`) due to nightly flags
    gn_args = %W[clang_version="#{llvm.version.major}" use_lld=#{OS.linux?}]
    if OS.linux?
      # unbundle toolchain uses separate host toolchain and reads BUILD_* variables
      ENV["BUILD_AR"]  = ENV["AR"] = which("ar") # llvm.opt_bin/"llvm-ar"
      ENV["BUILD_NM"]  = ENV["NM"] = which("nm") # llvm.opt_bin/"llvm-nm"
      ENV["BUILD_CC"]  = ENV.cc
      ENV["BUILD_CXX"] = ENV.cxx
      gn_args += %w[
        custom_toolchain="//build/toolchain/linux/unbundle:default"
        host_toolchain="//build/toolchain/linux/unbundle:default"
        use_system_libffi=true
      ]
    end

    ENV["CARGO_FEATURE_SYSTEM"] = "1" # libffi
    ENV["LCMS2_LIB_DIR"] = formula_opt_lib("little-cms2")
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    ENV["V8_FROM_SOURCE"] = "1" # per Homebrew/core policy, do not use prebuilt libv8.a
    # env args for building a release build with our python3 and ninja
    ENV["PYTHON"] = which("python3")
    ENV["NINJA"] = which("ninja")
    # Build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = llvm.opt_prefix
    ENV["GN_ARGS"] = gn_args.join(" ")

    features = ["deno_core/v8", "v8/v8"] if build.head?
    system "cargo", "install", "--no-default-features", "-vv", *args, *std_cargo_args(path: "cli", features:)
    bin.install_symlink bin/"deno" => "dx"
    generate_completions_from_executable(bin/"deno", "completions")
  end

  test do
    require "utils/linkage"

    IO.popen("deno run -A -r https://fresh.deno.dev fresh-project", "r+") do |pipe|
      pipe.puts "n"
      pipe.puts "n"
      pipe.close_write
      pipe.read
    end

    assert_match "# Fresh project", (testpath/"fresh-project/README.md").read

    (testpath/"hello.ts").write <<~TYPESCRIPT
      console.log("hello", "deno");
    TYPESCRIPT
    assert_match "hello deno", shell_output("#{bin}/deno run hello.ts")
    assert_match "Welcome to Deno!",
      shell_output("#{bin}/deno run https://deno.land/std@0.100.0/examples/welcome.ts")
    assert_match "hello deno", shell_output("#{bin}/dx -y cowsay hello deno")

    linked_libraries = [
      formula_opt_lib("sqlite")/shared_library("libsqlite3"),
    ]
    unless OS.mac?
      linked_libraries += [
        formula_opt_lib("libffi")/shared_library("libffi"),
      ]
    end
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"deno", library),
              "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
