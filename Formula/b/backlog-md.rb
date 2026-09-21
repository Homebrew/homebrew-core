class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://github.com/MrLesk/Backlog.md/archive/refs/tags/v1.52.0.tar.gz"
  sha256 "f6d6f4b97477e518bd89b549ab9bd403b9ea54a1f6328d6fdedfc47e9a25dab8"
  license "MIT"

  bottle do
    sha256 arm64_golden_gate: "9094f6ae3b0a1ddf40fd08af2b5806f6c0b83962eac14d6350686a3945e7c55a"
    sha256 arm64_tahoe:       "0f745e07e8759c56d08e8cb1e65be3a78799d6344cd9c116d78ae1482afc07fa"
    sha256 arm64_sequoia:     "15b1bd275487a581f4be607200333b0f0d218be9940f636769a2df09b4f150b4"
    sha256 arm64_linux:       "b5085296026a508d651ffb25b9dda5414b4214d5f5325c11107639c4fa3cb8dc"
    sha256 x86_64_linux:      "b323ce4ca871294490a40bdce55d0a0bb8c2be42422de28639372a411de5802b"
  end

  depends_on "bun" => :build

  on_linux do
    # `bun build --compile` embeds the runtime, so the output inherits bun's ICU linkage.
    depends_on "icu4c@78"
  end

  def install
    if OS.linux?
      bun_icu = Formula["bun"].deps.find { |dep| dep.name.match?(/^icu4c/) }.to_formula
      icu = deps.find { |dep| dep.name.match?(/^icu4c/) }.to_formula

      odie "Update icu4c dependency!" if bun_icu.name != icu.name
    end

    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"

    # Upstream injects the version at release time; the tagged `package.json` lags.
    ENV["BACKLOG_BUILD_VERSION"] = version.to_s

    # Not `bun run build`: that resolves `bun` from `node_modules/.bin`, and
    # `bun build --compile` embeds whichever runtime ran the build.
    system "bun", "scripts/build.ts"

    bin.install "dist/backlog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end
