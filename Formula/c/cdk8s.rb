require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.150.0.tgz"
  sha256 "e1d94fbd74302ceb4f6c305f3eaf184e0fc7148e502de1d5ddcbc06d22a47a81"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "afa965ec327192d119bd5b6ce077ce3cd3d9fdb5f271533910107f1d51190e97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afa965ec327192d119bd5b6ce077ce3cd3d9fdb5f271533910107f1d51190e97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afa965ec327192d119bd5b6ce077ce3cd3d9fdb5f271533910107f1d51190e97"
    sha256 cellar: :any_skip_relocation, sonoma:         "264129b1fb98f6f443c47f54da91a61d45c6aed874a896624bc3f2581845ba96"
    sha256 cellar: :any_skip_relocation, ventura:        "264129b1fb98f6f443c47f54da91a61d45c6aed874a896624bc3f2581845ba96"
    sha256 cellar: :any_skip_relocation, monterey:       "264129b1fb98f6f443c47f54da91a61d45c6aed874a896624bc3f2581845ba96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afa965ec327192d119bd5b6ce077ce3cd3d9fdb5f271533910107f1d51190e97"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
