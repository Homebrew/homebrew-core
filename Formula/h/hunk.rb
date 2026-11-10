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
    sha256 arm64_golden_gate: "9b2d86e05f4675f79747fa172b75af2306e2ea6b9fb79b7a1bbca3dd4db4ca31"
    sha256 arm64_tahoe:       "2efcf9ae89374d50364fa0c3e81c92276637e9f79a27eaa2319a2716afa3e09b"
    sha256 arm64_sequoia:     "097afeb522bc2a56d6e18dc542a582c56b0122335e036dab274180c8b35f46c6"
    sha256 arm64_linux:       "70775abf145028f571891c1cdf35506e2f046dc74bba8457bb9c1d1e2190a1e9"
    sha256 x86_64_linux:      "57b01d668392c9d6e88527531afa39abb062323d7ba1986ba1cf4c450e02f93c"
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
