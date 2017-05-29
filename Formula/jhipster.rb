require "language/node"

class Jhipster < Formula
  desc "Open Source application generator for creating Spring Boot + Angular projects in seconds!"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.5.2.tgz"
  sha256 "5df0edbbdb685df5ae598b53fb2def43b6c23bb75d44763a63cda69567395954"

  bottle :unneeded

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"jhipster", "info"
  end
end
