class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://github.com/MrLesk/Backlog.md/archive/refs/tags/v1.55.3.tar.gz"
  sha256 "d61d27116a36e01ce368d014a2717c792cb592d4aee6081e265cd8d543ce3b2d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "b8f9828e88cf7a8a6bafb301e54e06eb683a3b8876815482587198c8b8349005"
    sha256 arm64_tahoe:       "0a60f582649988e0b436d10ef49781d1766670d2f7a0968eaa47bc5c8b12912c"
    sha256 arm64_sequoia:     "6129eda92ccd3efabbe43dc7bc808a23a1ba0a665e0580798c281b02fb1ff8d5"
    sha256 arm64_linux:       "03a16a2123fe8dcecd7923ca02ae9c99cec9733361dd0558caf4af0fc7422a19"
    sha256 x86_64_linux:      "fd4a66d504867e9c3fb1b390367e4b928d3f681249bb963e7d5a46c7a8e72cb7"
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
