class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://github.com/anomalyco/opencode/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "eb16e1b9c504fff1e7d8679d7a88421967a403a7bb223e8993879a46735ff61f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "e94025144a945e78f047e79ff80976745c6a73b82511d712bee64bf45deee829"
    sha256 arm64_tahoe:       "0644b02edaed4e7922b043fdc796fa8c6be5d38fd3e7dee4c234ba0967437df4"
    sha256 arm64_sequoia:     "92ea92d7b313d1fcc62f1bb1600b17db4b4d305c921ffdbc15f90e597a7995e9"
    sha256 arm64_linux:       "a6e877b5614acaa09b51159073d491309c23c50a6d604612916d2621cacd258f"
    sha256 x86_64_linux:      "0b6685629209f53630f830cf1493d5741f125d195ca16588d9c7eae4e3bfe5df"
  end

  depends_on "bun" => :build
  depends_on "python@3.15" => :build
  depends_on "rust" => :build
  depends_on "zig@0.16" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "icu4c@79"
  end

  resource "opencode-pty" do
    url "https://github.com/anomalyco/opencode-pty/archive/refs/tags/v0.3.1.tar.gz"
    sha256 "101efcfde719cd9ead649d1fc1e1c31a31e89c854bf63b9cd2e977a7661f18a0"

    livecheck do
      url "https://raw.githubusercontent.com/anomalyco/opencode/refs/tags/v#{LATEST_VERSION}/packages/cli/package.json"
      strategy :json do |json|
        json.dig("dependencies", "@opencode-ai/pty")
      end
    end
  end

  # opencode-pty's build.rs requires a git checkout of the revision in its `ghostty-revision` file
  resource "ghostty" do
    url "https://github.com/ghostty-org/ghostty.git",
        revision: "ab0b9da9e88fcb4b0533a1854e84628f663930af"
    version "ab0b9da9e88fcb4b0533a1854e84628f663930af"

    livecheck do
      url "https://raw.githubusercontent.com/anomalyco/opencode/refs/tags/v#{LATEST_VERSION}/packages/cli/package.json"
      regex(/^(\h{40})$/i)
      strategy :json do |json, regex|
        pty_version = json.dig("dependencies", "@opencode-ai/pty")
        next if pty_version.blank?

        revision_url = "https://raw.githubusercontent.com/anomalyco/opencode-pty/refs/tags/v#{pty_version}/ghostty-revision"
        ghostty_revision = Homebrew::Livecheck::Strategy.page_content(revision_url)[:content]
        next if ghostty_revision.blank?

        ghostty_revision[regex, 1]
      end
    end
  end

  # Ghostty's `translate_c` dependency pins this archive in its build.zig.zon.
  # Zig fails to fetch it on macOS CI with `HttpHeadersOversize`.
  resource "aro" do
    url "https://github.com/vancluever/arocc/archive/ecbc5c799574e0da2758a961b12efa586007f03c.tar.gz"
    sha256 "aa54487bd727e8fa36744ff0a824dedb2f4ca45f4c2d4d9d2437cf5fd3d0ad1a"
  end

  def install
    # Build the persistent PTY helper from source instead of embedding the prebuilt npm binary
    (buildpath/"ghostty").install resource("ghostty")
    ENV["GHOSTTY_SOURCE_DIR"] = buildpath/"ghostty"
    cd "ghostty" do
      system "zig", "fetch", resource("aro").cached_download
    end
    resource("opencode-pty").stage do
      system "cargo", "install", *std_cargo_args(root: buildpath/"opencode-pty")
    end
    ENV["OPENCODE_PTY_BIN"] = buildpath/"opencode-pty/bin/opencode-pty"

    ENV["OPENCODE_VERSION"] = version.to_s
    ENV["OPENCODE_CHANNEL"] = "latest"

    # Fix server errors when building with Bun 1.4.2 by disabling splitting
    # https://github.com/anomalyco/opencode/issues/48645
    # https://github.com/NixOS/nixpkgs/issues/563241
    inreplace "packages/cli/script/build.ts", "splitting: true,", "splitting: false,"

    system "bun", "install", "--frozen-lockfile"

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
