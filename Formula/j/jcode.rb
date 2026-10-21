class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://github.com/1jehuang/jcode/archive/refs/tags/v0.99.0.tar.gz"
  sha256 "53eae57a45475078ddaf3b31b2f088c27685b3d2c511c57e700d4294d1fd17c9"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ede2c1e0c79d686f32d398fd4825de7b018502f81fae933cd3d85c069ba6bb5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6f2b48fa76c023c47180de1baffcee946c57b8bbea0d0c054b3c9e9f9de07fec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c66e2d4e65f4203f4ce59bf2631794e22ed7fd76920d3225cacb427011a473a9"
    sha256 cellar: :any,                 arm64_linux:       "aa77db9bc75ac1770475a220549e2aa1afbe4a182a0aef2cc7806103cb8fca1f"
    sha256 cellar: :any,                 x86_64_linux:      "79e02d51dff040ec33ff42a3b39356a24dad13021e9fca5ea9c74c510b3f97d3"
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
