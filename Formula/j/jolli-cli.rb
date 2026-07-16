class JolliCli < Formula
  desc "Capture and sync development memory from your terminal"
  homepage "https://jolli.ai"
  url "https://registry.npmjs.org/@jolli.ai/cli/-/cli-0.99.7.tgz"
  sha256 "7cd7faa286a02a7c719c5baf09b2d05f01c52d2bdb042e8094c7d1aecf4fae36"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["HOME"] = testpath.to_s
    ENV["DO_NOT_TRACK"] = "1"

    system "git", "init", "repo"
    cd "repo" do
      system bin/"jolli", "enable", "--yes"
      hook = testpath/"repo/.git/hooks/post-commit"
      assert_path_exists hook
      assert_match "JolliMemory post-commit hook", hook.read

      status = shell_output("#{bin}/jolli status")
      assert_match "Jolli Memory Status (v#{version})", status
      assert_match "Git", status
    end
  end
end
