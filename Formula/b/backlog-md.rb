class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://github.com/MrLesk/Backlog.md/archive/refs/tags/v1.57.2.tar.gz"
  sha256 "773eef102659638d3364684c4b34f13b2fdf0918a2ca6009b91bc404b84638ab"
  license "MIT"

  bottle do
    manifest_sha256 "cbef45b4fb9ca01aa38b096ad0c0fffeb60de699a7ea7653fcb570cc71497054"
    sha256 arm64_golden_gate: "2c7cb5298ee93885535140927d97881b479c672ca5324064a54ccc87bb39f74d"
    sha256 arm64_tahoe:       "af571bf9b1ddc995f8c9db3be83b65381fb5cc5f5d9ff9a749bb8ed76d9b48a4"
    sha256 arm64_sequoia:     "128e2dcd6256527fd46a98819220dd73b7f4fe1650e8f177a023a25a0266b070"
    sha256 arm64_linux:       "eb3235abf5922787228d9d6c5d6f1f0e14eccde055b0c89ecd770cd38c5c87b4"
    sha256 x86_64_linux:      "dd027c6fed9600a1e8848d65e5df400c8b443e5ee9bd84256ea6a7affd34aa5b"
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
