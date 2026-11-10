class Hunk < Formula
  desc "Review-first terminal diff viewer for agent-authored changesets"
  homepage "https://hunk.dev/"
  url "https://github.com/modem-dev/hunk/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "2c9fb535edf5eae1341395897cb0a875beb8b54ce63c3f2d1c467164057e8a6c"
  license "MIT"
  head "https://github.com/modem-dev/hunk.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "ee2dbfde1f7145781f71bcafbf7808778791d531bdceb558a49017912280970f"
    sha256 arm64_tahoe:       "26c3e36c12591b3afef294cc98d02442b108804519136200b9e1789eddd805b9"
    sha256 arm64_sequoia:     "0fb23342d7371b87d0092a5e09fafba1b65fffa217e2be64d956efd651ae5772"
    sha256 arm64_linux:       "7c6613ae59b58b5a6e25d08166b2a4a85f0a0659d45314fb388e44482b296779"
    sha256 x86_64_linux:      "e21a6f2b0d1d28e00d67770ed8249d770e420553474d9c312b9487600300dbc6"
  end

  depends_on "bun" => :build

  on_linux do
    depends_on "icu4c@79"
  end

  deny_network_access!

  def fetch
    system "bun", "install", "--frozen-lockfile", "--ignore-scripts"
  end

  def install
    system "bun", "run", "build:bin", "--runtime-executable", formula_opt_bin("bun")/"bun"
    libexec.install "dist/hunk", "dist/skills"
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
