class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.36.1/deno_src.tar.gz"
  sha256 "d3262bb024eb4aacf2090cdca66059a90a3176c07ebe1fcc0abcd4d83f2b047c"
  license "MIT"
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58ed1a26461c3559f2637cfd9c41141173f03f5f218d769dc6173b6488669989"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d55a9ccbc8961deb14c6b50fe5c44f9e3a9ffdc0706afc890161cf21673970bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8308482ecb351155bcbd6a56a6ee50911f13481e4d6047d8cd8eca96597bcb7f"
    sha256 cellar: :any_skip_relocation, ventura:        "eefba11f169b6a926d42a5bcc4aaf3a4eb5774aafa969eaebbd0548206a5a687"
    sha256 cellar: :any_skip_relocation, monterey:       "b706c0cc086d2c794df6ae0033d44b63ba71e7a6b72d79bdab5aa81fe5acaa9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e155c63b759fe316378ccd0c464edba3eb479c8ace3ac6c2fc06cb28a7d0ef07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "826b3fd1a2d86f8ef407c3033bb772cb0d8b76110643be8d7419962591ca58d8"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => :build
  depends_on "rust" => :build
  # TODO: after https://github.com/Homebrew/homebrew-core/pull/139382 is merged,
  # add "depends_on `sqlite` # needs `sqlite3_unlock_notify`" to try linking
  # with brewed `sqlite`.
  # Make sure to uncomment the related lines in `install` and `test` blocks too.

  uses_from_macos "libffi"
  uses_from_macos "xz"
  uses_from_macos "zlib"

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
    url "https://static.crates.io/crates/v8/v8-0.74.1.crate"
    sha256 "1202e0bd078112bf8d521491560645e1fd6955c4afd975c75b05596a7e7e4eea"
  end

  # Use the latest tag in https://github.com/denoland/v8/tags.
  resource "v8" do
    url "https://github.com/denoland/v8/archive/refs/tags/11.7.439.2-denoland-9fcf117b2e045094627c.tar.gz"
    sha256 "20661cff2d5f5fe7393d992225f7098bede350bc9415068a811ef08e95205b1b"
  end

  # To find the version of gn used:
  # 1. Find v8 version: https://github.com/denoland/deno/blob/v#{version}/Cargo.toml#L41
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

    # Avoid vendored dependencies.
    inreplace "ext/ffi/Cargo.toml",
              /^libffi-sys = "(.+)"$/,
              'libffi-sys = { version = "\\1", features = ["system"] }'
    inreplace "ext/node/Cargo.toml",
              /^libz-sys = { version = "(.+)", features = \["static"\] }$/,
              'libz-sys = "\\1"'
    # inreplace "Cargo.toml",
    #           /^rusqlite = { version = "(.+)", features = \["unlock_notify", "bundled"\] }$/,
    #           'rusqlite = { version = "\\1", features = ["unlock_notify"] }'

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

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    (testpath/"hello.ts").write <<~EOS
      console.log("hello", "deno");
    EOS
    assert_match "hello deno", shell_output("#{bin}/deno run hello.ts")
    assert_match "console.log",
      shell_output("#{bin}/deno run --allow-read=#{testpath} https://deno.land/std@0.50.0/examples/cat.ts " \
                   "#{testpath}/hello.ts")

    linked_libraries = [
      # Formula["sqlite"].opt_lib/shared_library("libsqlite3"),
    ]
    unless OS.mac?
      linked_libraries += [
        Formula["libffi"].opt_lib/shared_library("libffi"),
        Formula["zlib"].opt_lib/shared_library("libz"),
      ]
    end
    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"deno", library),
              "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
