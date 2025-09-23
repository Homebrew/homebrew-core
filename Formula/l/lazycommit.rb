class Lazycommit < Formula
  desc "Writes your git commit messages for you with AI using Groq"
  homepage "https://github.com/KartikLabhshetwar/lazycommit"
  url "https://registry.npmjs.org/lazycommitt/-/lazycommitt-1.0.16.tgz"
  sha256 "fcfea1be042f86d20f56cbeec623b19329b32c77ada50ba4a20acc540fbf976e"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    exe = bin/"lazycommit"
    exe = bin/"lzc" unless exe.exist?
    assert_path_exists exe

    if OS.mac?
      help = shell_output("#{exe} --help")
      assert_match "lazycommit", help

      hook_help = shell_output("#{exe} hook --help")
      assert_match "hook", hook_help
    else
      system "git", "init", "."
      system "git", "config", "user.email", "test@example.com"
      system "git", "config", "user.name", "Test User"

      (testpath/"README.md").write("# Test\n")
      system "git", "add", "README.md"

      system exe, "hook", "install"
      hook_path = testpath/".git/hooks/prepare-commit-msg"
      assert_path_exists hook_path
      assert_match "lazycommit", hook_path.read

      system exe, "hook", "uninstall"
      refute_path_exists hook_path
    end
  end
end
