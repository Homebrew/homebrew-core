class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.com/"
  url "https://github.com/denoland/deno/releases/download/v2.7.7/deno_src.tar.gz"
  sha256 "8786a1cb51d93275da845be33e0199a7a63c6ecc7839b8feec548097288c16ac"
  license "MIT"
  compatibility_version 1
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ea18a0a3e86d04085ea9a3d1c7a27c521ed86b171bfcbec52a63abc0d7b120be"
    sha256 cellar: :any,                 arm64_sequoia: "0e98f492dbd69bd01d69b8133fb68f69c0587c2b2957500487b1f5d90f9f28e1"
    sha256 cellar: :any,                 arm64_sonoma:  "d2f3e94079ec848a2f40ecc9ff76f615e0b8c7e0f62d51edd102e9d48afd03ef"
    sha256 cellar: :any,                 sonoma:        "a77c6e98914df099a070beb96f4c316e4050cc6b0baf0c3a13969f1927f1b133"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2117a71c844a305191bf80c3ca6064725843e44ce76341d077c163b205a38c72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f9e4d14334bc8b206d3a769e56bb45660608f8f80da584cc67d809807e4e161"
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
      s.gsub!(/^libffi-sys = "(.+)"$/,
              'libffi-sys = { version = "\\1", features = ["system"] }')
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
