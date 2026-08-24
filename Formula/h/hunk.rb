class Hunk < Formula
  desc "Review-first terminal diff viewer for agent-authored changesets"
  homepage "https://hunk.dev/"
  url "https://github.com/modem-dev/hunk/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "33e8eb2e116f93e8772f9465556f59cd018e87ac1a9825153afc632e6abaa980"
  license "MIT"
  head "https://github.com/modem-dev/hunk.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "7344f2eb101335f5d9532658ca1430e981b963887364f9d0ef297193be42b79c"
    sha256                               arm64_sequoia: "7344f2eb101335f5d9532658ca1430e981b963887364f9d0ef297193be42b79c"
    sha256                               arm64_sonoma:  "7344f2eb101335f5d9532658ca1430e981b963887364f9d0ef297193be42b79c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7ce3043c48226b491b27d7879195e9a84343ad31b100b06d502ba63ac50d758"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1cac5cf46703c197532083e350ebf34995b55056565d8ba6c0c478df9a6dc2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3192c171289877956f4ab70cc128fa860a9bdbb931e5d2e02afecf912925f9ec"
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
