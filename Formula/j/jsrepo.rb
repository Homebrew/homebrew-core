class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.8.5.tgz"
  sha256 "584644b661dcd7a47440e3d0c010e0c3eb86173a2a1b862e2af1df9a91ab5b52"
  license "MIT"

  bottle do
    manifest_sha256 "2e743ce45120d456e132f426e08fe3472c0b22fbaeaa3e5ef2c4054a3f1e68f9"
    sha256 cellar: :any,                 arm64_golden_gate: "097da26e06639bedef0f52d9c59a988024ab43d0108448e51271da4218ac922f"
    sha256 cellar: :any,                 arm64_tahoe:       "097da26e06639bedef0f52d9c59a988024ab43d0108448e51271da4218ac922f"
    sha256 cellar: :any,                 arm64_sequoia:     "097da26e06639bedef0f52d9c59a988024ab43d0108448e51271da4218ac922f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "63a6bb57ba99e7b1f00e35e907a39c50c013cba833c09ac41b633d96e423c812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "34ff6da3d50c48ee4a5f122422623a556aeecf9f3ef00a0bc70ad451dd879417"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-package",
        "version": "1.0.0"
      }
    JSON
    system bin/"jsrepo", "init", "--yes"
  end
end
