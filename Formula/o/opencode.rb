class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://github.com/anomalyco/opencode/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "937f351e1a1dc7bf48fdbe190e29c9cdb3ab24ad27619aa54411687b856a9871"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "4033cd095f9bac29968544340a4bd61d1b4bb3bdce913926b8bf4aa483620ece"
    sha256 arm64_tahoe:       "9c513a3bd93a198fb5120976ebf8ef5012c0a40f403d6a52274877e90561901c"
    sha256 arm64_sequoia:     "d42cd19f2de884cf971e982c46e8d62fd44ca7bfe270c9d255db742120f3bae7"
    sha256 arm64_linux:       "a8373e0b340f998a452ac98e270b7efb11b029da209a711e56ae84afbf517932"
    sha256 x86_64_linux:      "9d9a78d3958d60496049c5bc7314e91ebef9f803913418dce303a31030916ef1"
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
