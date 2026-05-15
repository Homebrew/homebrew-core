class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.com/"
  url "https://github.com/denoland/deno/releases/download/v2.7.14/deno_src.tar.gz"
  sha256 "617bc7247da4c8b031e3f155e10bfcb085ddd8f51625a73318dfd02fa5e939d0"
  license "MIT"
  compatibility_version 1
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c173b2146fa9e32723bdaa17d09064effc6983e49ae43ece4f3ac7d01dad403a"
    sha256 cellar: :any,                 arm64_sequoia: "d88372bf695f4379cbc8cd060c5c523cb2f83e67cbfd6065a19d7579dbde5eec"
    sha256 cellar: :any,                 arm64_sonoma:  "54d8559067a5d4cdcc31a67b9d75f2476ce25db00ab4d33d530347f279c47fb2"
    sha256 cellar: :any,                 sonoma:        "dfb4f1efc615757e5ece82ec58aae9443ba44592edd095e2fe105ae42f5b6158"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97993bdecbd458f1abca22c1031883e25f90f60c1cf866536e350d9c098a0752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "921b5f93391c4995d9b853100a10a35403fa57e1b646fd718ed1a11e7ee942cc"
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
