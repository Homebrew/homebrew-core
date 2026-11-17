class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://github.com/1jehuang/jcode/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "2de28d606ecd3b43c918694d1fb390da93b9e574412b1572e43bbda2621e3dc4"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "35f4bf3e7b19f1d0732de89cd195e9e0f04ca0c9e3cb29dcae3c9ee257fef368"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9a899e606caa25479edb5f309f220038fffdb6e0346cdf181380ba25c171e7ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a28139eee9406031a42b954470299244969afa866cab023a2a006b5c369160b8"
    sha256 cellar: :any,                 arm64_linux:       "63c0f0060e3c0964a6a0b7f7433f2808f7f4a253bc1840b9d9c1c8a2f1087cb7"
    sha256 cellar: :any,                 x86_64_linux:      "035cc42fd34b2f2e786af359adfb10364dbf21d5b3d0a33ba65aac42f7fd5a87"
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
