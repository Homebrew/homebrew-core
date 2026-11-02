class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://github.com/anomalyco/opencode/archive/refs/tags/v2.2.5.tar.gz"
  sha256 "04621edf6c47c2c7a36982ef39914d482c16977708fbd7b779f49f928bdc4fba"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "98e8d8085d7a8b14d92c7ff6b3ec339ed6afe97b3fd2f9b17526ed1035ae663b"
    sha256 arm64_tahoe:       "b493f7bde08feac1c29caf17dc4471fd5fc6d5cb39c604e04cb124730bf702d4"
    sha256 arm64_sequoia:     "8ece59a9d66b8169bdd6fe79c8dfb5328ac08409111484ae97da043b94bec92c"
    sha256 arm64_linux:       "59fe44f8de01e30282271e80899d4c1022426a4d7801668c661f638690792a78"
    sha256 x86_64_linux:      "bb7a1a968d3b363e1bfa0d924f506923bfea435a714bbfe66045fa847834b5c1"
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
