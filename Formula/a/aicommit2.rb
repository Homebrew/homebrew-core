class Aicommit2 < Formula
  desc "Reactive CLI that generates commit messages for Git and Jujutsu with AI"
  homepage "https://github.com/tak-bro/aicommit2"
  url "https://registry.npmjs.org/aicommit2/-/aicommit2-2.5.10.tgz"
  sha256 "a6fe3f4138e79966e2b0a812d4a9e7fb7a910370032eb396c8cc9e133226b65f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5dd7d2863f45c2eaf354a4007dccc5e78c51dea3b6313a5ea55ae091748091c7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # remove @github/copilot prebuilt native binaries to avoid non-native arch audit
    %w[prebuilds ripgrep clipboard].each do |dir|
      rm_r(libexec/"lib/node_modules/aicommit2/node_modules/@github/copilot"/dir)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aicommit2 --version")
    assert_match version.to_s, shell_output("#{bin}/aic2 --version")

    assert_match "Not in a Git repository", shell_output("#{bin}/aicommit2 2>&1", 1)

    system "git", "init"
    assert_match "No staged changes found", shell_output("#{bin}/aicommit2 2>&1", 1)

    (testpath/"test.txt").write "test content"
    system "git", "add", "test.txt"

    assert_match "No commit messages were generated", shell_output("#{bin}/aicommit2 2>&1", 1)
    shell_output("#{bin}/aicommit2 config set OPENAI.key=sk-test")
    assert_match "key: 'sk-test'", shell_output("#{bin}/aicommit2 config get OPENAI")
  end
end
