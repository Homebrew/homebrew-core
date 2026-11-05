class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.77.tgz"
  sha256 "397019caf47e2c4498018f9b8ed43fffb57c83118ed4f926fe1fbe29a0ec757a"
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
