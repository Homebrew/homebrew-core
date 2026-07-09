class Hunk < Formula
  desc "Review-first terminal diff viewer for agent-authored changesets"
  homepage "https://hunk.dev/"
  url "https://github.com/modem-dev/hunk/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "67b183a1664a1e85dcc42219f9ffe3422d74e123ec1e71be600ced94a0a1076f"
  license "MIT"
  head "https://github.com/modem-dev/hunk.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "2451674882ac0fe872c50d15ced4e0f9984023013caf23f7a668ef6e8ea45288"
    sha256                               arm64_sequoia: "2451674882ac0fe872c50d15ced4e0f9984023013caf23f7a668ef6e8ea45288"
    sha256                               arm64_sonoma:  "2451674882ac0fe872c50d15ced4e0f9984023013caf23f7a668ef6e8ea45288"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d369ea4071d607366a1aa75e7c24508de0f050583628b927ff9783cde04414c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aac74914738a0db06567b04614980b6a6faabb79b8876b9aa96c14f9b593841e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b1455a9d4b9b8e1ad915352e56d2f1311089d610277f82c342e8efff2685418"
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

    # Install the compiled binary and bundled skills
    libexec.install "dist/hunk" => "hunk"
    libexec.install "skills"
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
