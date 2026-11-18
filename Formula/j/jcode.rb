class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://github.com/1jehuang/jcode/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "9394106c7fa43f5f0797a43c2cd2df02ac61fb211ad0fb47aa1e0864a330087e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b5937873e855191becf718b0260ded183bddd89b0561ae593c35b95a4d961eaf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "36467dffb3268bb36cdac434591f3b2c99a4e57b5ead52b060b914e9d1acd8d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e3b1d1a1e793726bd66269ccaf576b27a73451a78803d2af300d0bc37ca82abf"
    sha256 cellar: :any,                 arm64_linux:       "10b89b615a7835da6d7a7511aeb71edc84413c9e29b3632bf724b19e0e441222"
    sha256 cellar: :any,                 x86_64_linux:      "eff5cd0b5f93d8f214229dfdd3c83ef67f249f8161b2593cb48d5232c7140491"
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
