require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.13.tgz"
  sha256 "411f8d15dff28e33c9e77c77f348739e2cdd91ec5bae9f4e29237796cdc7e1a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfb8c0bdd000d0916f4428253e1aa8ecc5b756cdc9d09bd2109c19135b13a1f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfb8c0bdd000d0916f4428253e1aa8ecc5b756cdc9d09bd2109c19135b13a1f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfb8c0bdd000d0916f4428253e1aa8ecc5b756cdc9d09bd2109c19135b13a1f2"
    sha256 cellar: :any_skip_relocation, ventura:        "f2b07fe71d0910bec3fc74f76ad82a2e229504ccb2fa15c359fd16ff1664f756"
    sha256 cellar: :any_skip_relocation, monterey:       "f2b07fe71d0910bec3fc74f76ad82a2e229504ccb2fa15c359fd16ff1664f756"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2b07fe71d0910bec3fc74f76ad82a2e229504ccb2fa15c359fd16ff1664f756"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfb8c0bdd000d0916f4428253e1aa8ecc5b756cdc9d09bd2109c19135b13a1f2"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
