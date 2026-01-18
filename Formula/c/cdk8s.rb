class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.203.18.tgz"
  sha256 "2631e693d3dbd72b31316cee22b9fe018a70bd9181cdc4c0c7fce8de891636a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "86b40e957937ce29e0a8575fa9c22a3c8e3ae2298ee889b5feaaf7dad39e3a43"
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
