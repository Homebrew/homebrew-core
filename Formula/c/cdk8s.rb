class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.75.tgz"
  sha256 "1acef03919ad7f3dbbf9c5f2a47a3ae1e84923c343cd5402486819eb87448ef2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1c7a3ca4ba2dc171237c0c2938cd1df1cae370ad78a5ec1f444cb63ac5fc0fd4"
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
