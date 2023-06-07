class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.34.0/deno_src.tar.gz"
  sha256 "38e990df1720c3f0b227eb2a247eb6779663e157b882bd7c86130715d89c9c4c"
  license "MIT"
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "460b134a43e2e3ec6aca40596908b2099abebf086188ba12f30765afc530c113"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28d552404f00d6fa4090fe650ff0aac60dbf5843c83ab2db0f1bd2d822825d76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca6a69e39f0d9ff3c221b25fd232036d5b1e1d4a05b4d754baa7c328c0b7a926"
    sha256 cellar: :any_skip_relocation, ventura:        "412af7a40d023a7ad7e24f9a7b3b1af4434888ae1d1b8ea0b6b7455032924806"
    sha256 cellar: :any_skip_relocation, monterey:       "94e5ed2224603787e51515571e46def9167cd342386ff364c6377c9ae322e38a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b58e35deeef8ab09c17ad4f373067ee25256d84c6a803c312d87637bd9b04370"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d173b95d3210fa6be31bc18387749da91f9ec246b2cc35b9e879ade8558bd65"
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
    url "https://static.crates.io/crates/v8/v8-0.72.0.crate"
    sha256 "d5c1d09f66ab7f69e36211c5488d47f683fef6b65b83a627cfd75ed9cef254e6"
  end

  # Use the latest tag in https://github.com/denoland/v8/tags.
  resource "v8" do
    url "https://github.com/denoland/v8/archive/refs/tags/11.5.150.2-denoland-3e797a2aacc68a76b40f.tar.gz"
    sha256 "727bcdbf76d504a91f7faa08d458bab87dac23b241962e140900c9433ecc3ab6"
  end

  # To find the version of gn used:
  # 1. Find v8 version: https://github.com/denoland/deno/blob/v#{version}/Cargo.toml#L44
  #    1.1. Update `rusty-v8` resource to use this version.
  # 2. Find ninja_gn_binaries tag: https://github.com/denoland/rusty_v8/blob/v#{v8_version}/tools/ninja_gn_binaries.py#L21
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
