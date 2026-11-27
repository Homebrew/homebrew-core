class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.25.0.tgz"
  sha256 "867a3bc6343025759dc050dd5b439f6039980e93b7f5023c9cace7a955c808d8"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "4d42c77bce9403ffb5cc8242b31296716cb976f45157875f5d22217edee8b187"
    sha256 cellar: :any_skip_relocation, all: "15bda3a73c000b5e70db9d814913a83fed102fe29031f5e145a31ce7464be4f8"
  end

  depends_on "node"

  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/e2b --version")
    assert_match "Not logged in", shell_output("#{bin}/e2b auth info")
  end
end
