class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.com/"
  url "https://github.com/denoland/deno/releases/download/v2.9.7/deno_src.tar.gz"
  sha256 "21069d2f4dd65b6832e3f5c373c24a43a8d35cb3d68d3841e15d0582bed39ea8"
  license "MIT"
  compatibility_version 1
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9d4e5f16210c3832db56e7eb439a2c5b080b01ba0041f69ce00a159d229627e6"
    sha256 cellar: :any, arm64_tahoe:       "98359a62d2ae77d6878240826153e426929d995f9774514fe91c946be9ad51cd"
    sha256 cellar: :any, arm64_sequoia:     "c327451c9e121a3f0743f7cd15c6fe74c5b501342d7bfa4323a8cb05531e8839"
    sha256 cellar: :any, arm64_linux:       "f6765e9904e080c3d56166f7feb39be4e6cf95b80542821ef5c980477698c429"
    sha256 cellar: :any, x86_64_linux:      "687976b368c278b70d7d12b533659867d04c5ea812feee42e988078a4cf068f4"
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
