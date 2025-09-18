class ImmichCli < Formula
  desc "Command-line interface for self-hosted photo manager Immich"
  homepage "https://immich.app/docs/features/command-line-interface"
  url "https://registry.npmjs.org/@immich/cli/-/cli-2.2.79.tgz"
  sha256 "9a553311943525915c6e215884f060c3859c6a5d0cc0b7f80f99f92dda5f5897"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "67af840e8e0e6097c2d331a614cd8ae7a4f73b23b715660aa642a771608ca424"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/immich --version")
    assert_match "No auth file exists. Please login first.", shell_output("#{bin}/immich server-info", 1)
  end
end
