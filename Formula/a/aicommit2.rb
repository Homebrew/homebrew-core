class Aicommit2 < Formula
  desc "Reactive CLI that generates commit messages for Git and Jujutsu with AI"
  homepage "https://github.com/tak-bro/aicommit2"
  url "https://registry.npmjs.org/aicommit2/-/aicommit2-2.5.16.tgz"
  sha256 "eb30b4b4d00ae1d55a2c29fa072e5f0ba6010644cac41d171da64881f38ae0fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "694bd84cedc42cfef8c914a8208c904c8de6c3a8207fa6f5de1f24510c388f78"
  end

  depends_on "node"

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
