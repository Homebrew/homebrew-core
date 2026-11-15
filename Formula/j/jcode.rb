class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://github.com/1jehuang/jcode/archive/refs/tags/v0.99.1.tar.gz"
  sha256 "f2ca7478f806ec04c69f9b8270a97c39d89f48b98d35a201c59051b03e144832"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f652272a5dad8f509b1625adb5f22e5847d2d5c95d0b0ca54d1dfb1362d1f7f7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "92761f1c2689102176579ddaba5f84f905e0ac883d5342daf1c7df93c8e00814"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7267a7b17d0dc07ab6fc8d9cd00d017dade4fd9dd95acd01ee8d5ca44d3868ad"
    sha256 cellar: :any,                 arm64_linux:       "743dda26f2da0a49a9e4b5a8b58be1d0a6aef80d764b265ddcdd60dfad7edd02"
    sha256 cellar: :any,                 x86_64_linux:      "125bd4dbb7c90b0289049a32dc40139ee012103767eb76ae8ecc6f3d86ddcb87"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access! :build

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Disable background auto-update by default
    inreplace "src/cli/args.rs",
              '#[arg(long, global = true, default_value = "true")]',
              '#[arg(long, global = true, default_value = "false")]'

    # Redirect `jcode update` to Homebrew
    inreplace "src/cli/dispatch.rs",
              "hot_exec::run_update()?;",
              'eprintln!("Please update jcode using: brew upgrade jcode");'

    system "cargo", "install", *std_cargo_args
    rm bin/"test_api"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jcode --version")
    assert_match "Please update jcode using: brew upgrade jcode", shell_output("#{bin}/jcode update 2>&1")

    system bin/"jcode-harness", "--cwd", testpath
    assert_match "alpha2", (testpath/"sample.txt").read
  end
end
