class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.88.tgz"
  sha256 "af0a11d2a2101c54be3177150e3247f32bffd61fb7ff951b2547cb087346804c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3d5fc8017211fd87fedd9af46385f4c200ae29c364f2eb639ee414673cc3b651"
  end

  depends_on "node"

  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
