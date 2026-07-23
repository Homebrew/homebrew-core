class Hunk < Formula
  desc "Review-first terminal diff viewer for agent-authored changesets"
  homepage "https://hunk.dev/"
  url "https://github.com/modem-dev/hunk/archive/refs/tags/v0.17.3.tar.gz"
  sha256 "86c37686352fcc6925e4080ea2cc414fe84c1b2af10a07dccfbc0e0fc275dbc2"
  license "MIT"
  head "https://github.com/modem-dev/hunk.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "11943615de2f975cdee6d47a4f2b813ab4debffe5098d300c9e778d125cbbb1e"
    sha256                               arm64_sequoia: "11943615de2f975cdee6d47a4f2b813ab4debffe5098d300c9e778d125cbbb1e"
    sha256                               arm64_sonoma:  "11943615de2f975cdee6d47a4f2b813ab4debffe5098d300c9e778d125cbbb1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "48f16626601de3aa817cabb92a11b25e699522376bda60502396e49c23951c36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "575cee30a2e3519898355b0c234de18b87553602ee2ecc706e0ce508cd484b9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acd9d041b23ddc21ff7e4552af3a880543bc13d092d842a3f7bdc0eb8be30656"
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
