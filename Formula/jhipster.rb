require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.5.2.tgz"
  sha256 "5df0edbbdb685df5ae598b53fb2def43b6c23bb75d44763a63cda69567395954"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    expected = <<-EOS.undent
      Executing jhipster:info
      Execution complete
    EOS
    assert_equal expected, shell_output("#{bin}/jhipster info")
  end
end
