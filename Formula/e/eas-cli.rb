class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-27.3.0.tgz"
  sha256 "1439ecb15f6c39e3fdb40a1682bc035b9e2e389edd524e94a7bd62c9d36e50a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c3017e5fc75ab5e004ab82fb882c766a07988367e4d55d992c25e2b4122d6127"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c3017e5fc75ab5e004ab82fb882c766a07988367e4d55d992c25e2b4122d6127"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c3017e5fc75ab5e004ab82fb882c766a07988367e4d55d992c25e2b4122d6127"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4497de9613ecae9d149b62de97acbc521ac3aae1037c582a3880e666ee7c404b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4497de9613ecae9d149b62de97acbc521ac3aae1037c582a3880e666ee7c404b"
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
