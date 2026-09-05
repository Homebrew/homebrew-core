class Hunk < Formula
  desc "Review-first terminal diff viewer for agent-authored changesets"
  homepage "https://hunk.dev/"
  url "https://github.com/modem-dev/hunk/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "47a7fc82112e334fcc592d7b3bf43a9a5822f933655db6547bc98446392fb2be"
  license "MIT"
  head "https://github.com/modem-dev/hunk.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "6d985f3bd2909b2b949514c552396864147ab3ef9ea5a5b4b63fe2179bbc351e"
    sha256                               arm64_sequoia: "6d985f3bd2909b2b949514c552396864147ab3ef9ea5a5b4b63fe2179bbc351e"
    sha256                               arm64_sonoma:  "6d985f3bd2909b2b949514c552396864147ab3ef9ea5a5b4b63fe2179bbc351e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c33eb23e749ccf4c95b49ec8b7a7da8b677c5878dbab6c6be3a766033532ebb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9726f0c1e3f63fccfbc0a5ce3445642afa273aa6095aa0babf4aff329fb9fae"
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
