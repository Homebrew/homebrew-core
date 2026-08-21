class Aicommit2 < Formula
  desc "Reactive CLI that generates commit messages for Git and Jujutsu with AI"
  homepage "https://github.com/tak-bro/aicommit2"
  url "https://registry.npmjs.org/aicommit2/-/aicommit2-2.11.1.tgz"
  sha256 "c60685e3f1f4e0d3f496b42980e7aebff87a654313fd32a6d08f2f6f3c77889f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ae714093bdb7f5d70ed80dbab27cf18f632e5ecbe5d029de97d5ef7eee411776"
  end

  depends_on "node"

  deny_network_access! [:postinstall, :test]

  def install
    # Optional dependencies include `@github/copilot-sdk`
    # which uses proprietary license
    (libexec/"aicommit2").install buildpath.glob("*")
    cd libexec/"aicommit2" do
      system "npm", "install", "--omit=optional", *std_npm_args(prefix: false)
      with_env(npm_config_prefix: libexec) do
        system "npm", "link"
      end
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aicommit2 --version")
    assert_match version.to_s, shell_output("#{bin}/aic2 --version")

    assert_match "Not in a Git repository", shell_output("#{bin}/aicommit2 2>&1", 1)

    system "git", "init"
    assert_match "No staged changes found", shell_output("#{bin}/aicommit2 2>&1", 1)

    (testpath/"test.txt").write "test content"
    system "git", "add", "test.txt"

    assert_match "No AI provider API keys configured.", shell_output("#{bin}/aicommit2 2>&1", 1)
    shell_output("#{bin}/aicommit2 config set OPENAI.key=sk-test")
    assert_match "key: 'sk-test'", shell_output("#{bin}/aicommit2 config get OPENAI")
  end
end
