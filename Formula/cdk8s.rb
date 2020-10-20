require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://github.com/awslabs/cdk8s"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-0.31.0.tgz"
  sha256 "3f4365b1c2fd2026426378a71f2995e3a27fa6d635f767e769ef13f8a784d442"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9aa9e251872a6ed43dbaf3c06b761779286f8f10608775d23c6789197470cf98" => :catalina
    sha256 "119db77f81ff73cdcc0deb457b711565c4c4b7f8d69e45f140f99916a571486a" => :mojave
    sha256 "254e068917bcbacf60c9dac975e01c304a1913ba0d8be43257cbc933f321885d" => :high_sierra
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
