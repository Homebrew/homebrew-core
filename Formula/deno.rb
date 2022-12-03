class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.28.3/deno_src.tar.gz"
  sha256 "85059ab2b88d53fea7aabf7c293d3d563a67fcb08e71f6298772891b8c25b0a6"
  license "MIT"
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba571cab7b27d607a4a4d97278707b2bc85be2513be1249e1e06b9d0bde08b74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c30971174a4617746384ca3016d08ad7d43718e100fc8cb89cefa48d1a6c37c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e84eff7893fa3e81ddef17225d984690586cb27e0fd13521f0ea6628b5278af"
    sha256 cellar: :any_skip_relocation, ventura:        "142e6aad94cbd07610fdbad3bc8c467360b358a9a7e3c506038ae2ae5067f510"
    sha256 cellar: :any_skip_relocation, monterey:       "2e23ce98a7d289c57bde6879c943ef66e580d27c4cde33a190c7037794dcd23c"
    sha256 cellar: :any_skip_relocation, big_sur:        "88783e45e9849a97923205b44ca066f8f6779682dac5bd54753b314f36710d73"
    sha256 cellar: :any_skip_relocation, catalina:       "e6b9c79a43e30bb79d03a65776bc20ce12b5a5959d68ef07d6b1a452479df68b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e4c928367506d487357d617b77508fb2ab702aacb7804b38f0473e8c30319d3"
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => :build
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
    url "https://static.crates.io/crates/v8/v8-0.58.0.crate"
    sha256 "8e9b88668afedf6ec9f8f6d30b446f622498da2ef0b3991a52e10f0ea8c6cc09"
  end

  resource "v8" do
    url "https://github.com/denoland/v8/archive/675c4782cc883e54d8a79b15348d7f0085d4f940.tar.gz"
    sha256 "7dbc0bf4052f08a9e856ffb2fa40faead904333461406126d3a20f3df94fc484"
  end

  # To find the version of gn used:
  # 1. Find v8 version: https://github.com/denoland/deno/blob/v#{version}/Cargo.toml#L43
  # 2. Find ninja_gn_binaries tag: https://github.com/denoland/rusty_v8/tree/v#{v8_version}/tools/ninja_gn_binaries.py
  # 3. Find short gn commit hash from commit message: https://github.com/denoland/ninja_gn_binaries/tree/#{ninja_gn_binaries_tag}
  # 4. Find full gn commit hash: https://gn.googlesource.com/gn.git/+/#{gn_commit}
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "bf4e17dc67b2a2007475415e3f9e1d1cf32f6e35"
  end

  # patch textwrap, remove in next release
  patch do
    url "https://github.com/denoland/deno/commit/c3b75c692c6392dd59ba7203f4f94d702eb20e27.patch?full_index=1"
    sha256 "d64096893d41c13ba358f43d4300f7438371dca2918e96f92fa41acf2c1eb425"
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
    inreplace "Cargo.toml",
              /^v8 = { version = ("[\d.]+"),.*}$/,
              "v8 = { version = \\1, path = \"./v8\" }"

    if OS.mac? && (MacOS.version < :mojave)
      # Overwrite Chromium minimum SDK version of 10.15
      ENV["FORCE_MAC_SDK_MIN"] = MacOS.version
    end

    python3 = "python3.11"
    # env args for building a release build with our python3, ninja and gn
    ENV.prepend_path "PATH", Formula["python@3.11"].libexec/"bin"
    ENV["PYTHON"] = Formula["python@3.11"].opt_bin/python3
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
