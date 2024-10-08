class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.240.tgz"
  sha256 "9685787b31ef5216328e52a1522005eddfafa6f2235a8c3f27243cc606c01b9c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b7b12416f5e7b6b9ee96fcc4f134181b2163e01e49923d296b72214d2c8475a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b7b12416f5e7b6b9ee96fcc4f134181b2163e01e49923d296b72214d2c8475a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b7b12416f5e7b6b9ee96fcc4f134181b2163e01e49923d296b72214d2c8475a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8759824efb9b7617dadb99aec23b0cae1250fe7f9e3b093e8587459ace1b14d"
    sha256 cellar: :any_skip_relocation, ventura:       "b8759824efb9b7617dadb99aec23b0cae1250fe7f9e3b093e8587459ace1b14d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b7b12416f5e7b6b9ee96fcc4f134181b2163e01e49923d296b72214d2c8475a"
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
