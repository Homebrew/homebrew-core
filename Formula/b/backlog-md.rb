class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://github.com/MrLesk/Backlog.md/archive/refs/tags/v1.57.2.tar.gz"
  sha256 "773eef102659638d3364684c4b34f13b2fdf0918a2ca6009b91bc404b84638ab"
  license "MIT"

  bottle do
    manifest_sha256 "b65e1919b03da57293fb6af68e9e181aa0b2e5a32e41cd0b8566186f37b10a00"
    sha256 arm64_golden_gate: "0f926d8f920c1f3ef4c4fe01cdbbf24b067a800d1a992edcf635675238d7d250"
    sha256 arm64_tahoe:       "5175fdbda9387d76ff7d8e3b2fa6ceabf9e46c9b2aa7848116a86e72538c9348"
    sha256 arm64_sequoia:     "049e6c654a8a15e5d651b06bd6db1c63621b57941ec88ab5ef0a87c8ff3e435a"
    sha256 arm64_linux:       "5444b54e8b925539b772f35ff29b5254729bfdbc88298c117e8e3bd5f1d902c3"
    sha256 x86_64_linux:      "4bd36d53f39e598ba5658a27859d14a8b5eadfbe9a2ec7ae6fe24baf92922f98"
  end

  depends_on "bun" => :build

  on_linux do
    # `bun build --compile` embeds the runtime, so the output inherits bun's ICU linkage.
    depends_on "icu4c@79"
  end

  deny_network_access!

  def fetch
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
  end

  def install
    if OS.linux?
      bun_icu = Formula["bun"].deps.find { |dep| dep.name.match?(/^icu4c/) }.to_formula
      icu = deps.find { |dep| dep.name.match?(/^icu4c/) }.to_formula

      odie "Update icu4c dependency!" if bun_icu.name != icu.name
    end

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
