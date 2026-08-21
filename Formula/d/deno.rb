class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.com/"
  url "https://github.com/denoland/deno/releases/download/v2.9.5/deno_src.tar.gz"
  sha256 "b3d1d66e47d74f5bda84d5a80282135b7d8f2e336fbcf98c75be32f18130864a"
  license "MIT"
  compatibility_version 1
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5d4b6c62f6262a041581c0e5e16f73f1a1e7a6ee94de97bcc05af170ab5953be"
    sha256 cellar: :any, arm64_sequoia: "3479e3d0949f307bf81fd3c48e03970b1965c4f6ad2c118810beacff52c4ebb1"
    sha256 cellar: :any, arm64_sonoma:  "836911ffc383ecc1ea6d9a0ac2d5de351165716fcb4f12975c446848ef95ed09"
    sha256 cellar: :any, sonoma:        "a54bec6ab18105622d98b4148fa479c1812458a42d3ec7f604304b2e3ac3148c"
    sha256 cellar: :any, arm64_linux:   "a211a7a4b0d3a36c796ef421d7a86dc8d212ad76cfa487f1f1607a8371619841"
    sha256 cellar: :any, x86_64_linux:  "ce0fa492468b819c4444aa8e1a7451aeeed494517fb482df4f0e860f3ce8efe3"
  end

  depends_on "cmake" => :build
  depends_on "lld" => :build
  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "little-cms2"
  depends_on "sqlite" # needs `sqlite3_unlock_notify`

  uses_from_macos "python" => :build
  uses_from_macos "libffi"

  on_macos do
    depends_on xcode: ["15.0", :build] # v8 12.9+ uses linker flags introduced in xcode 15
  end

  on_linux do
    depends_on "glib" => :build
    depends_on "pcre2" => :build
    depends_on "zlib-ng-compat"
  end

  conflicts_with "dxpy", because: "both install `dx` binaries"

  def llvm = Formula["llvm"]

  def install
    # Avoid vendored dependencies.
    ENV["CARGO_FEATURE_SYSTEM"] = "1" # libffi
    ENV["LCMS2_LIB_DIR"] = formula_opt_lib("little-cms2")
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    # env args for building a release build with our python3 and ninja
    ENV["PYTHON"] = which("python3")
    ENV["NINJA"] = which("ninja")
    # Build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = llvm.prefix

    # use our clang version, and disable lld because the build assumes the lld
    # supports features from newer clang versions (>=20)
    ENV["GN_ARGS"] = "clang_version=#{llvm.version.major} use_lld=#{OS.linux?}"

    # Enable V8 without `__runtime_defaults`, which brings the `upgrade` subcommand and vendored zlib-ng
    features = ["deno_core/v8", "v8/v8"]
    system "cargo", "install", "--no-default-features", "-vv", *std_cargo_args(path: "cli", features:)
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
