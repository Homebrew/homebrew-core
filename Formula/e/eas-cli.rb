class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-21.0.3.tgz"
  sha256 "2949098fd32b7e1bfe888cbd68bfdd89bbad7402ff425bed1c20601b80ee1f15"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8cb046135086e1bcb174188546f7987376cc79b4ebfb733a81bf74758132556a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eas --version")
    assert_match "Run this command inside a project directory",
                 shell_output("#{bin}/eas diagnostics 2>&1", 1)
  end
end
