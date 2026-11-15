class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.83.tgz"
  sha256 "36908a30a34b8401c0119d0654f19f72dd8897d611b2b06211be99c54dc3a33f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4ceb26ac13ca7b36e470f49b929095923bece61d694138631df7113d8137ff5c"
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
