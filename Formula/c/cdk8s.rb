class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.76.tgz"
  sha256 "9fc969f36a8bb275f23e90bc61619fbf3fed71b7971f0af64fbb9ada15ad30be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6ee54c762147bf33d43ac4ce50ba294682c682eb0229a1732aea344f1313ed11"
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
