class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://github.com/1jehuang/jcode/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "2a787f8828e24fe3fef455ba924c3a64ea38bc6ffc683d647e3b238269ddfba1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "80651d5418f4a8502219eb40c97e0eab837ef2cb7b6950a26cc7a0c399485c32"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c57bd55d0e3b53b2088466a2f37f79896acc683585e742f29cd1e414ef4e0bbb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eac813e950f34c9a6d6a08f19bf7d65dc1fab7b9c58c0803746c3bc0b9dfc8de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "435095d9668f765bbf05991ac24b50b1336dc00a1bc32b41d90df851fbcd162a"
    sha256 cellar: :any,                 arm64_linux:       "bc9ef822fa5b32efc8682957a115ee082bf00b7fec0d50fbd4e77c8757544e3f"
    sha256 cellar: :any,                 x86_64_linux:      "e4faf0ec1dd604fa63f5ae8b1817625fbc0058aa3646aaf8e1852e24c46119ca"
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
    # Version comes from `Cargo.toml`, which is not bumped for every release tag
    ENV["JCODE_BUILD_SEMVER"] = version.to_s

    # Disable background auto-update by default
    inreplace "src/cli/args.rs",
              '#[arg(long, global = true, default_value = "true")]',
              '#[arg(long, global = true, default_value = "false")]'

    # Redirect `jcode update` to Homebrew
    inreplace "src/cli/dispatch.rs",
              "hot_exec::run_update(resolved_channel, set_channel_only)?;",
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
