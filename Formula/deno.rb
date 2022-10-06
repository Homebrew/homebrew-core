class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.26.1/deno_src.tar.gz"
  sha256 "fee389f62ff7b558bcaec0ff4a9ec3894c07a981b12b5b122cbc4175dd5285d7"
  license "MIT"
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1f0145689b0c3e6da05fe0464d4ad2bb27f3d29bc5a0985b580367568ffe49f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54137824074d27f357556135357f3f21c6f7e9e9bead777a8e122bb21d6066c5"
    sha256 cellar: :any_skip_relocation, monterey:       "77ad30f3bebe27c23d05d511f95f3c0c667571758c266262e9cdeb14a9520c1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "86c2e0693bee37a6a95e704341295cf4be7e2608a48ffdbc5ecc6ec731105073"
    sha256 cellar: :any_skip_relocation, catalina:       "d6e1d2fb22c724f257362e58d143a8c7e12f3b2b76b5b426fa66e05d7ca30b19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4d91d2b9d0764925c15cb0addf783a331d7df8788934eb468681a9b7217984e"
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "python@3.10" => :build
  depends_on "rust" => :build

  uses_from_macos "xz"

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
  # TODO: Remove this and `v8` resource when https://github.com/denoland/rusty_v8/pull/1063 is released
  resource "rusty-v8" do
    url "https://static.crates.io/crates/v8/v8-0.51.0.crate"
    sha256 "e72791f754a6517e86d88e4521baad3a7d428ce54e266ba560b8747b2a99b946"
  end

  resource "v8" do
    url "https://github.com/denoland/v8/archive/652f540e7eb25fba4598c66be9cd875c171e1810.tar.gz"
    sha256 "4fedc7fe94f6164e2ffdbc465a5a8d5808b6b057e05993d384524cd77e195d5a"
  end

  # To find the version of gn used:
  # 1. Find v8 version: https://github.com/denoland/deno/blob/v#{version}/core/Cargo.toml
  # 2. Find ninja_gn_binaries tag: https://github.com/denoland/rusty_v8/tree/v#{v8_version}/tools/ninja_gn_binaries.py
  # 3. Find short gn commit hash from commit message: https://github.com/denoland/ninja_gn_binaries/tree/#{ninja_gn_binaries_tag}
  # 4. Find full gn commit hash: https://gn.googlesource.com/gn.git/+/#{gn_commit}
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "bf4e17dc67b2a2007475415e3f9e1d1cf32f6e35"
  end

  def install
    # Work around files missing from crate
    # TODO: Remove this at the same time as `rusty-v8` + `v8` resources
    (buildpath/"v8").mkpath
    resource("rusty-v8").stage do |r|
      system "tar", "--strip-components", "1", "-xzvf", "v8-#{r.version}.crate", "-C", buildpath/"v8"
    end
    resource("v8").stage do
      cp_r "tools/builtins-pgo", buildpath/"v8/v8/tools/builtins-pgo"
    end
    inreplace %w[core/Cargo.toml serde_v8/Cargo.toml],
              /^v8 = { version = ("[\d.]+"),.*}$/,
              "v8 = { version = \\1, path = \"../v8\" }"

    if OS.mac? && (MacOS.version < :mojave)
      # Overwrite Chromium minimum SDK version of 10.15
      ENV["FORCE_MAC_SDK_MIN"] = MacOS.version
    end

    python3 = "python3.10"
    # env args for building a release build with our python3, ninja and gn
    ENV.prepend_path "PATH", Formula["python@3.10"].libexec/"bin"
    ENV["PYTHON"] = Formula["python@3.10"].opt_bin/python3
    ENV["GN"] = buildpath/"gn/out/gn"
    ENV["NINJA"] = Formula["ninja"].opt_bin/"ninja"
    # build rusty_v8 from source
    ENV["V8_FROM_SOURCE"] = "1"
    # Build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = Formula["llvm"].prefix

    resource("gn").stage buildpath/"gn"
    cd "gn" do
      system python3, "build/gen.py"
      system "ninja", "-C", "out"
    end

    # cargo seems to build rusty_v8 twice in parallel, which causes problems,
    # hence the need for -j1
    # Issue ref: https://github.com/denoland/deno/issues/9244
    system "cargo", "install", "-vv", "-j1", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"deno", "completions")
  end

  test do
    (testpath/"hello.ts").write <<~EOS
      console.log("hello", "deno");
    EOS
    assert_match "hello deno", shell_output("#{bin}/deno run hello.ts")
    assert_match "console.log",
      shell_output("#{bin}/deno run --allow-read=#{testpath} https://deno.land/std@0.50.0/examples/cat.ts " \
                   "#{testpath}/hello.ts")
  end
end
