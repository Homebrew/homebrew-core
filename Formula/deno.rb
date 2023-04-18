class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.32.4/deno_src.tar.gz"
  sha256 "4861b2c88b21473ba635a89f4400777215efd785edac08cb15baf1de75f91c54"
  license "MIT"
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "308c913644706ed39adab246b0e30c22364b0c7bfd9c1a52689232a91d8f81bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de14fe214293315b50b870649dcfd8383444c350236e8957dc709bce33ccc740"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3f14c7d15a64fb9b1e798536fc06a7cedbcee4caa98a3cb830fde633da54abb"
    sha256 cellar: :any_skip_relocation, ventura:        "50bed081b9242bdb26046b819a755db9274fe2ee5579f301b0fb4513f7c6f50f"
    sha256 cellar: :any_skip_relocation, monterey:       "7b46c847d207baf34a6f4ceceeacdc539290e44bcdfc6a7df9724d71cec88921"
    sha256 cellar: :any_skip_relocation, big_sur:        "13f3707c3088572a38bc95a1224b13b8a2e37c073b4dc0e6c4436b6da7290ab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1eb7cbcb59327d066cca22778b5a326c3ab5acc3224a2963d45241408070b00e"
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
  # TODO: Remove this and `v8` resource when https://github.com/denoland/rusty_v8/issues/1065 is resolved
  resource "rusty-v8" do
    url "https://static.crates.io/crates/v8/v8-0.68.0.crate"
    sha256 "81c69410b7435f1b74e82e243ba906d71e8b9bb350828291418b9311dbd77222"
  end

  resource "v8" do
    url "https://github.com/denoland/v8/archive/02aef2fce7750d472d84fa361df3946d447a6489.tar.gz"
    sha256 "60dbd81e1a676b7d174f0fa8e563b224ec0986e21e2776f608a879fa6f118d9b"
  end

  # To find the version of gn used:
  # 1. Find v8 version: https://github.com/denoland/deno/blob/v#{version}/Cargo.toml#L44
  # 2. Find ninja_gn_binaries tag: https://github.com/denoland/rusty_v8/tree/v#{v8_version}/tools/ninja_gn_binaries.py#L21
  # 3. Find short gn commit hash from commit message: https://github.com/denoland/ninja_gn_binaries/tree/#{ninja_gn_binaries_tag}
  # 4. Find full gn commit hash: https://gn.googlesource.com/gn.git/+/#{gn_commit}
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "70d6c60823c0233a0f35eccc25b2b640d2980bdc"
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
