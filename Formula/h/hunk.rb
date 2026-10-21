class Hunk < Formula
  desc "Review-first terminal diff viewer for agent-authored changesets"
  homepage "https://hunk.dev/"
  url "https://github.com/modem-dev/hunk/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "108120c25c64017d1b608e1aa2b7317dc1bb9220285fdccffcde6c67d89ace04"
  license "MIT"
  head "https://github.com/modem-dev/hunk.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_golden_gate: "a1be049ccf08e34c2a87688cea738ad9a092e2707ae75bb1268c7dc9d3cddbc1"
    sha256                               arm64_tahoe:       "a1be049ccf08e34c2a87688cea738ad9a092e2707ae75bb1268c7dc9d3cddbc1"
    sha256                               arm64_sequoia:     "a1be049ccf08e34c2a87688cea738ad9a092e2707ae75bb1268c7dc9d3cddbc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3c7e40bc300711d615ba5dab36d753d4af0a00770aaa5fb508834a90ce818de6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "734966626ed961025dc9eb9d38d333e92cbce99c790f86bd761ff7e6907e907d"
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
    libexec.install "dist/hunk"
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
