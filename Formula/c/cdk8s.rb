class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.84.tgz"
  sha256 "593130504f3ac1ae28dd6eb97caa333c366fe45cd9096fcc1c24f775cf36f9d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1ae070ddad1fe2b9b23c435fa16364d7445bc884fc8b08608b83c76ad5c1bb3b"
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
