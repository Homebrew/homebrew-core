class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.1.0.tgz"
  sha256 "95018eb73d4e6916ce101e6dfb25f1add30ebe64a34116fb70a97601978737a2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eeac9b271905ee3ea1c469e4e5926aae299000036d928d3047e5aacf619d8590"
    sha256 cellar: :any,                 arm64_sequoia: "8826f14c1c2d4a7aef3a02196f0391c730a32182235b4f5ebae50263f524f1c3"
    sha256 cellar: :any,                 arm64_sonoma:  "8826f14c1c2d4a7aef3a02196f0391c730a32182235b4f5ebae50263f524f1c3"
    sha256 cellar: :any,                 sonoma:        "8743585335082cbef7f55d4687a29dd41f5a6a023cf8c6d1cc7890550080722b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8793f7fe264814f68d37f52825cc87d402e9ec771c748a12e5313cc11dcf7bfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccbccd85bca35b472e40f80a7c1f5be2d65413571b8b5446333bccc6c105b89c"
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
