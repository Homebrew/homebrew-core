require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.115.tgz"
  sha256 "1c8e72f0a8f18e37ec9f683af5371c6c1d4b698707ee9cf00f02a996eb32f40d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45d81e3a6a69dd2d5e4f540e97a22b39af2d42a2d81caa633a566f11125c70ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8ef2826d58d49f42991f3c618ecac4c6a44f152e6bbddc55b6c3507d271b716"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26ccc3d0852b816c46e44499b476e766143b46c18035c8c6e697d0c8398021eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "c18cebe309af5f4caefd595d3ea7f9a409410e09e6cefe8a0ca00e10f00d726f"
    sha256 cellar: :any_skip_relocation, ventura:        "5b841c510ec1fe2eb232fb60ddfcd082ef8e87405626ac7d69f9ac9cb303f411"
    sha256 cellar: :any_skip_relocation, monterey:       "03fee138ef7ea7cd0cb75d69bc3f5ee0cad9681e4e62261cabd88149694fb800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bc16f58bd08988ecf12f52b3f67595d1abbb45e58989514e54d1ca59f6df13d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
