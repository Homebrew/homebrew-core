class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-27.7.0.tgz"
  sha256 "2ae71f45a088d76c9b1c974d84889d3efc2b223b6dde3aeb9f39dab5ceac67b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9b5141914b1930c30ae3cecc4e1ce199b9288e0b6abb85670b175ddc023a183d"
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
