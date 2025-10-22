class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.0.0.tgz"
  sha256 "931352ef364a48145e5c6e98e6ed3c3d85d4f572e5589d0ac9bf90f1f456f6f9"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "639429fceef6fe8aff3c23fb4286d6ce937c985b10ac27739126fc88dd8947b5"
    sha256 cellar: :any,                 arm64_sequoia: "8e17257271c5d3ba912026c9076fe6a23f3c4515e970fb6eacbc388fecf0a16d"
    sha256 cellar: :any,                 arm64_sonoma:  "8e17257271c5d3ba912026c9076fe6a23f3c4515e970fb6eacbc388fecf0a16d"
    sha256 cellar: :any,                 sonoma:        "6fbfdfe2568aa3c4ac1d94cd2565279c14e4122b1efbb12e991393ee894de72a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "087089e2b83291f020e6f80e973b6d1b04703534c1154e0034f5164cd92b7061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0090d8ec503692de5c6ccb3ca2d63d44a0de76083bb4e0ede90857bc9282ce8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "@acme/repo",
        "version": "0.0.1",
        "scripts": {
          "test": "echo 'Tests passed'"
        }
      }
    JSON

    system bin/"nx", "init", "--no-interactive"
    assert_path_exists testpath/"nx.json"

    output = shell_output("#{bin}/nx 'test'")
    assert_match "Successfully ran target test", output
  end
end
