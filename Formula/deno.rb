class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.24.1/deno_src.tar.gz"
  sha256 "47917607edad9551933997ffd6eeaf45447836d9637c3f805669eef52f104d65"
  license "MIT"
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e80196c99c15f3e6c721a9dfd71c1eb30042c8e0c8ec2a1b69ca64f64050f65c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e24491a5688a662a11fea25fbda0c9b6e59777a2f7e25da695e5c78a2e7b65f"
    sha256 cellar: :any_skip_relocation, monterey:       "2cdc33f9d435c5676b18451882ba45e0699f72d82c3309c8bf364e9fcba785e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "14db851e91f04ba3d92c1789965fde71edefe697474fb8def6ce03e371c283d6"
    sha256 cellar: :any_skip_relocation, catalina:       "c8f4c89abb35b47fa01e22f538903f764034f81489f2e78278aa4c45c7537e59"
    sha256                               x86_64_linux:   "e18ba1c0efac957bb3f0f7bb6942766cee4eaeb46c9e6b09c8573a330bfd34ba"
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
    depends_on "gcc"
    depends_on "glib"

    # Temporary v8 resource to work around build failure due to missing MFD_CLOEXEC in Homebrew's glibc.
    # We use the crate as GitHub tarball lacks submodules and this allows us to avoid git overhead.
    # TODO: Remove when deno's v8 is on 10.5.x, a backport/patch is added, or Homebrew uses a newer glibc.
    # Ref: https://chromium.googlesource.com/v8/v8.git/+/3d67ad243ce92b9fb162cc85da1dc1a0ebe4c78b
    resource "v8" do
      url "https://static.crates.io/crates/v8/v8-0.47.1.crate"
      sha256 "be156dece7a023d5959a72dc0d398d6c95100ec601a2cea10d868da143e85166"
    end
  end

  fails_with gcc: "5"

  # To find the version of gn used:
  # 1. Find v8 version: https://github.com/denoland/deno/blob/v#{version}/core/Cargo.toml
  # 2. Find ninja_gn_binaries tag: https://github.com/denoland/rusty_v8/tree/v#{v8_version}/tools/ninja_gn_binaries.py
  # 3. Find short gn commit hash from commit message: https://github.com/denoland/ninja_gn_binaries/tree/#{ninja_gn_binaries_tag}
  # 4. Find full gn commit hash: https://gn.googlesource.com/gn.git/+/#{gn_commit}
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "bf4e17dc67b2a2007475415e3f9e1d1cf32f6e35"
  end

  # To find the version of tinycc used, check the commit hash referenced from
  # https://github.com/denoland/deno/tree/v#{version}/ext/ffi
  resource "tinycc" do
    url "https://github.com/TinyCC/tinycc.git",
        revision: "afc136262e93ae85fb3643005b36dbfc30d99c42"
  end

  def install
    # Work around Homebrew's old glibc using same temporary patch as `v8` formula.
    # TODO: Remove this at the same time as `v8` resource
    if OS.linux?
      (buildpath/"v8").mkpath
      resource("v8").stage do |r|
        system "tar", "--strip-components", "1", "-xzvf", "v8-#{r.version}.crate", "-C", buildpath/"v8"
      end
      inreplace "v8/v8/src/base/platform/platform-posix.cc" do |s|
        s.sub!(/^namespace v8 {$/, <<~EOS)
          #ifndef MFD_CLOEXEC
          #define MFD_CLOEXEC 0x0001U
          #define MFD_ALLOW_SEALING 0x0002U
          #endif

          namespace v8 {
        EOS
      end
      inreplace %w[core/Cargo.toml serde_v8/Cargo.toml],
                /^v8 = { version = ("[\d.]+"),.*}$/,
                "v8 = { version = \\1, path = \"../v8\" }"
    end

    if OS.mac? && (MacOS.version < :mojave)
      # Overwrite Chromium minimum SDK version of 10.15
      ENV["FORCE_MAC_SDK_MIN"] = MacOS.version
    end

    # env args for building a release build with our python3, ninja and gn
    ENV.prepend_path "PATH", Formula["python@3.10"].libexec/"bin"
    ENV["PYTHON"] = Formula["python@3.10"].opt_bin/"python3"
    ENV["GN"] = buildpath/"gn/out/gn"
    ENV["NINJA"] = Formula["ninja"].opt_bin/"ninja"
    # build rusty_v8 from source
    ENV["V8_FROM_SOURCE"] = "1"
    # Build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = Formula["llvm"].prefix
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    resource("gn").stage buildpath/"gn"
    cd "gn" do
      system "python3", "build/gen.py"
      system "ninja", "-C", "out"
    end

    resource("tinycc").stage buildpath/"tinycc"
    cd "tinycc" do
      ENV.append_to_cflags "-fPIE" if OS.linux?
      system "./configure", "--cc=#{ENV.cc}"
      system "make"
    end

    ENV["TCC_PATH"] = buildpath/"tinycc"

    # cargo seems to build rusty_v8 twice in parallel, which causes problems,
    # hence the need for -j1
    # Issue ref: https://github.com/denoland/deno/issues/9244
    system "cargo", "install", "-vv", "-j1", *std_cargo_args(path: "cli")

    bash_output = Utils.safe_popen_read(bin/"deno", "completions", "bash")
    (bash_completion/"deno").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"deno", "completions", "zsh")
    (zsh_completion/"_deno").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"deno", "completions", "fish")
    (fish_completion/"deno.fish").write fish_output
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
