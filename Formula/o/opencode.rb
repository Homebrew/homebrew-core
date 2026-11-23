class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://github.com/anomalyco/opencode/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "c36a18288b4679ca48cb30b905c3c7ffdc0c8ff1e0e72fb13f38f0f2d29f1b37"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "d6d1490b989f4c1f071481bac1d7cec866f2bb6dcde9d197e4a6c0824672e931"
    sha256 arm64_tahoe:       "aabfee5b6d6c7b88898fc9fd39f4520f27a941b23c8111c6b8941f9c0ca47bba"
    sha256 arm64_sequoia:     "544383d0c8a75558864e982d9614ebe328d8ff0224f78ccab7382effe309703d"
    sha256 arm64_linux:       "e7d9df705f8a07bac6354b5f870b6f60793fc4e6bc8db06fbe79b60e5acb3e23"
    sha256 x86_64_linux:      "70f282b7593a565a5387f363e30d03a2726cd4eedf31a088b2ef81667c1fe410"
  end

  depends_on "bun" => :build
  depends_on "rust" => :build
  depends_on "zig@0.16" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "icu4c@79"
  end

  # opencode-pty's build.rs requires a git checkout of the revision in its `ghostty-revision` file
  resource "ghostty" do
    url "https://github.com/ghostty-org/ghostty.git",
        revision: "ab0b9da9e88fcb4b0533a1854e84628f663930af"
    version "ab0b9da9e88fcb4b0533a1854e84628f663930af"

    livecheck do
      url "https://raw.githubusercontent.com/anomalyco/opencode/refs/tags/v#{LATEST_VERSION}/packages/process-daemon/ghostty-revision"
      regex(/^(\h{40})$/i)
    end
  end

  allow_network_access! :test

  def fetch
    (buildpath/"ghostty").install resource("ghostty")
    cd "ghostty" do
      system "zig", "build", "--fetch=all"
    end
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "packages/process-daemon/Cargo.toml"
    system "bun", "install", "--frozen-lockfile"
  end

  def install
    ENV["GHOSTTY_SOURCE_DIR"] = buildpath/"ghostty"
    ENV["OPENCODE_PTY_BIN"] = buildpath/"opencode-pty/bin/opencode-pty"
    ENV["OPENCODE_VERSION"] = version.to_s
    ENV["OPENCODE_CHANNEL"] = "latest"
    ENV["OPENCODE_ZIG_CPU"] = Hardware.zig_cpu(ENV.effective_arch).to_s

    # Build the persistent PTY helper from source instead of embedding the prebuilt npm binary
    system "cargo", "install", *std_cargo_args(path: "packages/process-daemon", root: buildpath/"opencode-pty")

    cd "packages/cli" do
      system "bun", "--bun", "./script/build.ts", "--single", "--skip-install"
      bin.install Pathname.pwd.glob("dist/cli-*/bin/opencode").first
    end

    generate_completions_from_executable(bin/"opencode", shell_parameter_format: "--completions=")
  end

  test do
    ENV["OPENCODE_DISABLE_AUTOUPDATE"] = "1"
    ENV["OPENCODE_DISABLE_MODELS_FETCH"] = "1"

    assert_match version.to_s, shell_output("#{bin}/opencode --version")

    (testpath/"opencode.json").write <<~JSON
      { "agent": { "brewtest": { "description": "Homebrew test agent", "prompt": "hi" } } }
    JSON
    # The standalone server listens on localhost, so network access can't be denied here
    entries = JSON.parse(shell_output("#{bin}/opencode api --standalone config.get"))
    project = entries.find { |entry| entry["path"] == (testpath/"opencode.json").realpath.to_s }
    assert_equal "hi", project.dig("info", "agents", "brewtest", "system")
  end
end
