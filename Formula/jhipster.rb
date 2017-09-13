require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.8.1.tgz"
  sha256 "595b9fcfab3483b56d26d29942d8fae58fce3e82f7fec77cc8a8a8c24c50a343"

  bottle do
    cellar :any_skip_relocation
    sha256 "0550deabbb5d2e6b76c990c7564a42bad47628d418c045258ed806c168e91887" => :sierra
    sha256 "b15a68fff5ddf26b52f0193f6c4be8dc72118997fc3216f3724f16b19b7b5644" => :el_capitan
  end

  depends_on "node"
  depends_on "yarn"
  depends_on :java => "1.8+"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Execution complete", shell_output("#{bin}/jhipster info")
  end
end
