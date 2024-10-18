class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.249.tgz"
  sha256 "4bc84adb5ebe933f6270038fa8246540ae83918d1451cc4abddbd6e466a22567"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cb711e394976666a9fd654a3178e38d4b2dcb5328fdafb18016eb76db356750"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cb711e394976666a9fd654a3178e38d4b2dcb5328fdafb18016eb76db356750"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8cb711e394976666a9fd654a3178e38d4b2dcb5328fdafb18016eb76db356750"
    sha256 cellar: :any_skip_relocation, sonoma:        "3837294f73bbe19ed51a2bf8377231c4c75ce6650806a56aa2f5a0b54ec8914b"
    sha256 cellar: :any_skip_relocation, ventura:       "3837294f73bbe19ed51a2bf8377231c4c75ce6650806a56aa2f5a0b54ec8914b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cb711e394976666a9fd654a3178e38d4b2dcb5328fdafb18016eb76db356750"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
