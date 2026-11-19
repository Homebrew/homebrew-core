class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.87.tgz"
  sha256 "d9dbf79bb42034beb36afba3c5346b3afcaf683197f2d214f7249574c1c0ed36"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3d5fc8017211fd87fedd9af46385f4c200ae29c364f2eb639ee414673cc3b651"
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
