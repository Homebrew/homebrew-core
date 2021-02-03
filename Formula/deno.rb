class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.7.1/deno_src.tar.gz"
  sha256 "4229add28cc3f347b3f8622ef3b75dac1be2b90bd002566f050f83bf90e0de70"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4e6a4622cc668a7ee57c0c414e89c59aba792c4dee9741c23d7ff2fa42c7f4cf"
    sha256 cellar: :any_skip_relocation, big_sur:       "8d396d56b4b7d46e5567c81678fd9187a8e606b67c4bad4c7074468a32285f6d"
    sha256 cellar: :any_skip_relocation, catalina:      "75e850c745ebb5b57dc0c881e7ceb78b41682dd017c2fc1c6559ccc682f5c72d"
    sha256 cellar: :any_skip_relocation, mojave:        "c52facc1125be9390c79a7dcf119986df341207d423074825a67f624c37c0515"
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "rust" => :build
  depends_on "sccache" => :build
  depends_on xcode: ["10.0", :build] # required by v8 7.9+
  depends_on :macos # Due to Python 2 (see https://github.com/denoland/deno/issues/2893)

  uses_from_macos "xz"

  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "53d92014bf94c3893886470a1c7c1289f8818db0"
  end

  def install
    # env args for building a release build with our clang, ninja and gn
    ENV["GN"] = buildpath/"gn/out/gn"
    ENV["NINJA"] = Formula["ninja"].opt_bin/"ninja"
    ENV["SCCACHE"] = Formula["sccache"].opt_bin/"sccache"
    # build rusty_v8 from source
    ENV["V8_FROM_SOURCE"] = "1"
    # Build with llvm. We don't remove llvm from HOMEBREW_LIBRARY_PATHS
    # as this causes build failures. This does not create a runtime dependency.
    ENV["CLANG_BASE_PATH"] = Formula["llvm"].prefix

    resource("gn").stage buildpath/"gn"
    cd "gn" do
      system "python", "build/gen.py"
      system "ninja", "-C", "out"
    end

    cd "cli" do
      system "cargo", "install", "-vv", *std_cargo_args
    end

    bash_output = Utils.safe_popen_read("#{bin}/deno", "completions", "bash")
    (bash_completion/"deno").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/deno", "completions", "zsh")
    (zsh_completion/"_deno").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/deno", "completions", "fish")
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
