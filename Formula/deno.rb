class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.34.3/deno_src.tar.gz"
  sha256 "0e236aa5aa7e56e6e0119df5f2ab8cce603659ea9243cc25d88d28b3ed443d86"
  license "MIT"
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d327941f25f09edfeab0e69f4161cad60f2891a4c61dc56c1a3bdf168272f699"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cef76aa9785bf1e1ff01e575487f7d9b6c70b21c41ea813a9a7ef5fe714319b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93a68a0eb1c2d31e196ab0b45cadb656acafbd9054af514f6ca16709e0e0a606"
    sha256 cellar: :any_skip_relocation, ventura:        "6167f7d646a764d4b53a981d6d7ce82e045833a57f6d53c33a45c1cf6098963a"
    sha256 cellar: :any_skip_relocation, monterey:       "b23b251299cf0d4541b1d87f38ded0e58c703656d7b26d493d3e0580b315d326"
    sha256 cellar: :any_skip_relocation, big_sur:        "f841c45292ce97f4cb12ae0ee8dcf93aea80409fba6111aaf074b39ade7ba01f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cb227b5583b60aaa49cd16a9f776f70149efca85303b47062530cf51b41d8e2"
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
    url "https://static.crates.io/crates/v8/v8-0.73.0.crate"
    sha256 "e1bd3f04ba5065795dae6e3db668ff0b628920fbd2e39c1755e9b62d93660c3c"
  end

  # Use the latest tag in https://github.com/denoland/v8/tags.
  resource "v8" do
    url "https://github.com/denoland/v8/archive/refs/tags/11.5.150.9-denoland-fdc3bc4b606c4de667be.tar.gz"
    sha256 "5f05a056536679462eaf170e02ea87e0836de20405616d499d194b2931feed14"
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
