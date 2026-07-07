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
    sha256                               arm64_tahoe:   "4485aec1eca90785c9ce40bfa426fc4f81778093afab0191c15780307b39e2d5"
    sha256                               arm64_sequoia: "4485aec1eca90785c9ce40bfa426fc4f81778093afab0191c15780307b39e2d5"
    sha256                               arm64_sonoma:  "4485aec1eca90785c9ce40bfa426fc4f81778093afab0191c15780307b39e2d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6cc964666640577dcf3dd1e7a2cd46c4a4ff05e6dae24262108156f8fa24657"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6633d45c408c4a81fff55b983f933a1ebd17ac3d67106ed9032c4eac932673d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bb3a9380196d1ed2625f7ce6276f47f39fc575b4c5ff684379d1fe81e7f4fe8"
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
