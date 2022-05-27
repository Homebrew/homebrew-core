class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.23.1/deno_src.tar.gz"
  sha256 "619169f952f1730870a7d1039bf3d65f030f520f5a7d2f50673fd1899ceeace7"
  license "MIT"
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef4b117706e007e417804196ce60872e1ce6f7202ea3f862184c25278cccffb2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebb26e6a478fbbfe089532b5ded2661ddf7e14041a9c8619a8baf10c6ff84877"
    sha256 cellar: :any_skip_relocation, monterey:       "85628d306b00dca9cdc8a989f859bd8074427607f61a158c71bdc5ae792c38b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "b866adea0a356019407a3172095f708831f48ca7a4578d5b8d47e587d4575f50"
    sha256 cellar: :any_skip_relocation, catalina:       "1c4a4feccfcc738dfa6127eadde112793ee82521043e4df21eec13f655ff360b"
    sha256                               x86_64_linux:   "b5a64d4feae3eae0b2837dfed6d0d7b1bfea07a8a643f6c6abc565ac9cf4cf73"
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
    # Ref: https://chromium.googlesource.com/v8/v8.git/+/8fdb91cdb80ae0dd0223c0d065f724e480c5e0db
    resource "v8" do
      url "https://static.crates.io/crates/v8/v8-0.44.2.crate"
      sha256 "5ee18f5327bc32aeacce7027886683f4f9bd06ee2a17db17860bf0ab008a4013"
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
                /^v8 = ("[\d.]+")$/,
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
