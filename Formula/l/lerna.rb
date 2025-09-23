class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-8.2.4.tgz"
  sha256 "56a7479e3d07601dee4effd74986c911c3c2c6ed13509f33925b89febf1f051b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aa24ec5e1404e716f68145999ad2cfec3fcbe37b9f4afd88fc0952c7f5958a1a"
    sha256 cellar: :any,                 arm64_sequoia: "d2026ce78a4c0a5f45c89b1caa08e34c39cc621a013ed3127ebcd2f406dd7ab5"
    sha256 cellar: :any,                 arm64_sonoma:  "d2026ce78a4c0a5f45c89b1caa08e34c39cc621a013ed3127ebcd2f406dd7ab5"
    sha256 cellar: :any,                 arm64_ventura: "d2026ce78a4c0a5f45c89b1caa08e34c39cc621a013ed3127ebcd2f406dd7ab5"
    sha256 cellar: :any,                 sonoma:        "5ac38e8bfe162784a51e104d818829acaa14ff7fe9a1e22a9ea39aeedc1910ea"
    sha256 cellar: :any,                 ventura:       "5ac38e8bfe162784a51e104d818829acaa14ff7fe9a1e22a9ea39aeedc1910ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69074c4c83a8fbe7248982befc0393d38aa8795167940b3d47b32ab7d8a9aa9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bf3ab3ef4cf98d2e26ba74f4454bcdd41eacfcb8b19a8ba079a390b6fadcdf6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
