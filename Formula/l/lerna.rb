class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-10.1.1.tgz"
  sha256 "ffa7bfd387c52f8e22d367dbcc91da4d873a814e02f42a01381e35279967b4ea"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "2e9a53771e729e880bca0922026a5b6dc96d2deb3dac61fa3ae46f1e9b9e87ce"
    sha256 cellar: :any,                 arm64_tahoe:       "2e9a53771e729e880bca0922026a5b6dc96d2deb3dac61fa3ae46f1e9b9e87ce"
    sha256 cellar: :any,                 arm64_sequoia:     "2e9a53771e729e880bca0922026a5b6dc96d2deb3dac61fa3ae46f1e9b9e87ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "442301fc1064b6dd9392d334c8892cd5e4a9d1bdf4407d54e16405b9935eb729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f3689190992894225627983540de2bcd4954dca160dede0c8aeef8aa35d3cc38"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
