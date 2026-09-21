class Hunk < Formula
  desc "Review-first terminal diff viewer for agent-authored changesets"
  homepage "https://hunk.dev/"
  url "https://github.com/modem-dev/hunk/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "dd591936f924933746b45d0ecdd39c7fda625f45619b467ca577a601b0f67b04"
  license "MIT"
  head "https://github.com/modem-dev/hunk.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_golden_gate: "454336f6bd747701b925f5833ad1986497bde75e8ad9e15ffae51a0eff1e06fd"
    sha256                               arm64_tahoe:       "454336f6bd747701b925f5833ad1986497bde75e8ad9e15ffae51a0eff1e06fd"
    sha256                               arm64_sequoia:     "454336f6bd747701b925f5833ad1986497bde75e8ad9e15ffae51a0eff1e06fd"
    sha256                               arm64_sonoma:      "454336f6bd747701b925f5833ad1986497bde75e8ad9e15ffae51a0eff1e06fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e81546e66c63b0b2823b0d61308e39c06a3636af5633f98e08dce83c844a9dc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c7c26d05238d1c0ec89df72d9bacf905822b5b0ffc299751a919002b79c24284"
  end

  depends_on "bun" => :build
  depends_on "node" => :build

  def install
    # --ignore-scripts skips simple-git-hooks postinstall (fails on extracted tarball, not a git repo)
    # and bun's postinstall (needed by bun build --compile), so we re-run bun's postinstall manually
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
    Dir.chdir("node_modules/bun") { system "node", "install.js" }

    # Build the standalone binary (bun build --compile embeds the Bun runtime)
    system "bun", "run", "build:bin"

    # Install the compiled binary and bundled skills. The repository-root
    # `skills` holds maintainer-only documents that upstream does not ship.
    libexec.install "dist/hunk" => "hunk"
    libexec.install "packages/hunk/skills"
    (bin/"hunk").write_env_script libexec/"hunk", HUNK_INSTALL_SOURCE: "homebrew"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hunk --version")

    help_output = shell_output("#{bin}/hunk --help")
    assert_match("hunk diff", help_output)
    assert_match("hunk skill path", help_output)

    skill_path = shell_output("#{bin}/hunk skill path").strip
    assert_match(/SKILL\.md\z/, skill_path)
    assert_path_exists skill_path, "hunk skill path did not resolve to a bundled skill file: #{skill_path}"
  end
end
