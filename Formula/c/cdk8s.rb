class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.55.tgz"
  sha256 "cbfbc0a0a1bcaa8cceba2cb599cd7fe15f0c705ccb8c18a2d5de0c44c109ee54"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6db573e9180ef0fcbdfbaa41624f998117ccfc054752c31fc1487e9415de1fa0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
