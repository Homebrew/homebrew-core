class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.86.tgz"
  sha256 "768c046dc7494971b385876daccaca297bb0e893b7235aa93232b09d240526cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b6c9c0a6b8d158c060e4814da03810e2aef82b8b9efd393bbf09519ae04c1db3"
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
