class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-25.2.0.tgz"
  sha256 "a2789262de72875375a206a477c1d0ad0284f2bdbefedfc6d5c7c9f8eff14ffe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "373a5d8dc93053beeb511158cdf01cda740eafb7b04bb56efb5bfb46f2c74ac8"
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
