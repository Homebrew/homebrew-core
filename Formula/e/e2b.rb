class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.26.0.tgz"
  sha256 "6a9245a4bce5450b82c7c0db8ed09f83506b0cb5a194faf90eabee851524af0b"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "51c5928fec32a24210a706260a25b49ee6cddfb8f155438b0dfc912d748a85b6"
    sha256 cellar: :any_skip_relocation, all: "b959f97cd549754307e5808c4de752bd596dace0189668425a257ffcd840215d"
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
