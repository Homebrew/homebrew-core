require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.163.0.tgz"
  sha256 "7c4cdae73ac5655ce45d40c5c22fa4602f55287f7da693580f56af892e237de4"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb34927204212636afc96d75127aa66a175876b4e90a7d5b9c1e39bb1a27583f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb34927204212636afc96d75127aa66a175876b4e90a7d5b9c1e39bb1a27583f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb34927204212636afc96d75127aa66a175876b4e90a7d5b9c1e39bb1a27583f"
    sha256 cellar: :any_skip_relocation, sonoma:         "89ba9f7c55f23b86424d4c720034e766bb1f421a9955992d59cca34820c48663"
    sha256 cellar: :any_skip_relocation, ventura:        "89ba9f7c55f23b86424d4c720034e766bb1f421a9955992d59cca34820c48663"
    sha256 cellar: :any_skip_relocation, monterey:       "89ba9f7c55f23b86424d4c720034e766bb1f421a9955992d59cca34820c48663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb34927204212636afc96d75127aa66a175876b4e90a7d5b9c1e39bb1a27583f"
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
