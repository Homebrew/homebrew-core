class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://github.com/1jehuang/jcode/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "c1e09e34ca0f3bd4d179326fe151cf03c85c6fc843096f454b8383a7eb6e0383"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "80851e8f4d72b2a9ee3bcca628863430d1e98bac6742cc61a114d223b3097064"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d09cdca5ea4f30f23713a7beaa6e8f2ca454792509513d7fa56ca459fb549ca7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a6c33464be864883a792757e9120e2272ce210418d5adf146d84fd6264fcd160"
    sha256 cellar: :any,                 arm64_linux:       "11fd35db71b64204d61fced5ec5c9bedc0cb34b9fe47bbecbcd30cc1debbf6f4"
    sha256 cellar: :any,                 x86_64_linux:      "7651371f69b1a043e41f2eef1b1559e30c88836141509bd73de7d0d7f98b91c0"
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
              "hot_exec::run_update(channel.as_deref())?;",
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
