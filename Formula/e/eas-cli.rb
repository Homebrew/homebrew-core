class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-27.6.0.tgz"
  sha256 "943300de5cc2a5dfe8d870809e6e23e0016c2ad267d380c6c3b289ca6aa9e256"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e4993a123de249cba99dc226fef8739fbd8bfeacfde7af75349ac94ccb2408e6"
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
