class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.89.tgz"
  sha256 "7f9604b7af7bd55fbc7333aa22d0dcc6a1d9afc6b1cf8406ce647a08dacedfe9"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "5e6d9bce9ce8843f44df94ef820780b16396829264110ab79dbdfe042d0ae5b3"
    sha256 cellar: :any_skip_relocation, all: "5e369580af3466283bb6f03b2d4fd998944ad5ffb8a5d0b2e76be3deb8f94ace"
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
