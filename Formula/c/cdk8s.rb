class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.15.tgz"
  sha256 "d008ab8bc528098101192c1499e92429f0e053eab8bf760ff2e726c633267e5c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "18298a8371031189e4a95e408732d6b445b718d25f33093beab88cece19cc025"
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
