class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.79.tgz"
  sha256 "1814f0a4cc2df1be14371d0a353eae659990928b4822d9023f116ec9d9df6884"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "52cd519b183fa3916582e38987e33d6232fc618d0a87ed7866c384406ed20310"
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
