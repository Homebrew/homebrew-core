require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.144.0.tgz"
  sha256 "a099c2c3a13ca639652ef1a427a5c3664992aa6e7641ee1e3e2aaaca2a4bc116"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f4dbb67fa167042573f5a9f2681e888fd9314720353080182fece8dd6b2ea71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f4dbb67fa167042573f5a9f2681e888fd9314720353080182fece8dd6b2ea71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f4dbb67fa167042573f5a9f2681e888fd9314720353080182fece8dd6b2ea71"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac51bb0f12f915904ca5b14b645435a9a8282280697a7fcc99f7193ef509f44a"
    sha256 cellar: :any_skip_relocation, ventura:        "ac51bb0f12f915904ca5b14b645435a9a8282280697a7fcc99f7193ef509f44a"
    sha256 cellar: :any_skip_relocation, monterey:       "ac51bb0f12f915904ca5b14b645435a9a8282280697a7fcc99f7193ef509f44a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f4dbb67fa167042573f5a9f2681e888fd9314720353080182fece8dd6b2ea71"
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
