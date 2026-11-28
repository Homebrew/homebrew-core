class Jcode < Formula
  desc "AI coding agent harness for the terminal"
  homepage "https://jcode.sh"
  url "https://github.com/1jehuang/jcode/archive/refs/tags/v1.1.7.tar.gz"
  sha256 "836161baa29a7ffc4cd5556038a9bd604b55b1ff70e4cdc00fb1523140520ed8"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "e557c540d007846da856be672ab91e63034e74f1e1ef93f7e9d097fd64e6072f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6715e33b96927821a4a00c6d4c6970f1c37e5c13ea7edb279c784c949b517bc9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bbb38d79b65f257db4b556bba7a971ab0b124bb6ec48a059c978fb5211b2863e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b7346d03cbc8442b4f96eef97b13443b17c4ce9f38737ce46e599eaed5621aeb"
    sha256 cellar: :any,                 arm64_linux:       "7490d0b4bda193458474b13b633a311e31bcaace963d57501cfab28d98762344"
    sha256 cellar: :any,                 x86_64_linux:      "59a82d9c7a1fb6463b0743f228ad9561d732a8e3db164928fe3e77259b96c821"
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
