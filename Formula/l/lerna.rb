class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-10.1.2.tgz"
  sha256 "ee91c398736d85ad998d14aee6f3fbd3787b307d7167bb562ce8991655f42f9a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "e23a240dd561a3b4c75dd40067a72ef1f738faf01572bdb0453bcfeb9a6ea21a"
    sha256 cellar: :any,                 arm64_tahoe:       "e23a240dd561a3b4c75dd40067a72ef1f738faf01572bdb0453bcfeb9a6ea21a"
    sha256 cellar: :any,                 arm64_sequoia:     "e23a240dd561a3b4c75dd40067a72ef1f738faf01572bdb0453bcfeb9a6ea21a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2994f0e2eb3986ada2a7e9ce9b8ff5187440dbec3ee380081a7a4c7da05b4130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "73dd87446df6b35380d330027ecb0c0cd4bfef8c3467cfdc4ca572b6a2e566b3"
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
