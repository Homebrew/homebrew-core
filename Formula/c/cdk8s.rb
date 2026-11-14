class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.82.tgz"
  sha256 "be08d4e60a9e11266dedd8c5434636fb8f409312d3f6e931c368deb004f61f00"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "43e688bc379645d80ac8bb70d02970e0232c7d1b27dafa3509b41dc99111840d"
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
