class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-27.4.0.tgz"
  sha256 "2a406460348f6e9dc4e96c2846ef09882a1887000af968a84058559d74bf9c44"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a9c50a32c366a898daced185adea56cf782a1288a3cd343a84faf83ad3c6ae73"
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
