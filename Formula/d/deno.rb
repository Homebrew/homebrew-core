class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.com/"
  url "https://github.com/denoland/deno/releases/download/v2.8.2/deno_src.tar.gz"
  sha256 "7cddb4439dcdc40c95e49ed9a17440dcf967db0052dfa330693358afd625c218"
  license "MIT"
  compatibility_version 1
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "43b73d8d662e2d0651b4cfee10d4a13cb9a2e9d9297d6674a3b696d884606474"
    sha256 cellar: :any, arm64_sequoia: "f656c3f96683ab8a1c3247bc7fe4a19830bc3e6dc07ab998538ba0135b264ec6"
    sha256 cellar: :any, arm64_sonoma:  "b3e1a8dd335ef60b29bcaa9eb69daac1c8a88a8df8b707c1cc0183c7f8e7459c"
    sha256 cellar: :any, sonoma:        "32e1cf2be09206a448def0536d03fea227f0497c5a35c610116f1e1924c49291"
    sha256 cellar: :any, arm64_linux:   "69c07081ad449cb83673bfec609b0fa71412ceca7b01a2fdfb0c3e693620e261"
    sha256 cellar: :any, x86_64_linux:  "05925ce4acea06b0ba12e959106db7048e8316a34f9ba84727f3fa2b3537a3d5"
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

  def llvm
    Formula["llvm"]
  end

  def install
    inreplace "Cargo.toml" do |s|
      # https://github.com/Homebrew/homebrew-core/pull/227966#issuecomment-3001448018
      s.gsub!(/^lto = true$/, 'lto = "thin"')

      # Avoid vendored dependencies.
      s.gsub!(/^libffi = "(.+)"$/, 'libffi = { version = "\\1", features = ["system"] }')
      s.gsub!(/^rusqlite = { version = "(.+)", features = \["unlock_notify", "bundled", "session"/,
              'rusqlite = { version = "\\1", features = ["unlock_notify", "session"')
    end

    ENV["LCMS2_LIB_DIR"] = Formula["little-cms2"].opt_lib
    # env args for building a release build with our python3 and ninja
    ENV["PYTHON"] = which("python3")
    ENV["NINJA"] = which("ninja")
    # Build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = llvm.prefix

    # use our clang version, and disable lld because the build assumes the lld
    # supports features from newer clang versions (>=20)
    ENV["GN_ARGS"] = "clang_version=#{llvm.version.major} use_lld=#{OS.linux?}"

    system "cargo", "install", "--no-default-features", "-vv", *std_cargo_args(path: "cli")
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
      Formula["sqlite"].opt_lib/shared_library("libsqlite3"),
    ]
    unless OS.mac?
      linked_libraries += [
        Formula["libffi"].opt_lib/shared_library("libffi"),
      ]
    end
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"deno", library),
              "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
