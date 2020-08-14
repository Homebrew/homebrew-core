require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://github.com/awslabs/cdk8s"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-0.27.0.tgz"
  sha256 "77010866c1e04f3c4ef09bd9076b3adb32c8585f4580acebf7599d2834be861b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6a3d58777381571fbabf4c023cb13da0145f1e77e58c39b50bc90616755578d" => :catalina
    sha256 "945c71f494fcba0afecf91172181f826d4bb311256a7999b8912098d835f5e7f" => :mojave
    sha256 "51fc6cfa21ea4d2f42a93de0908f12a3fea0f3cc3dea4bc83e663c4854a9a440" => :high_sierra
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
