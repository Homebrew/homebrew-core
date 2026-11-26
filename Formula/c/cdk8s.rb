class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.88.tgz"
  sha256 "af0a11d2a2101c54be3177150e3247f32bffd61fb7ff951b2547cb087346804c"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "81e897e94851d6003327c8e2d8786e9d8aa8faeec491943732a6d6f7fcbdca7a"
    sha256 cellar: :any_skip_relocation, all: "0a63bafe3262a9c7c21e12609e392176e31ecd4ee726733045c91b8559b18f75"
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
