require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.5.2.tgz"
  sha256 "5df0edbbdb685df5ae598b53fb2def43b6c23bb75d44763a63cda69567395954"

  bottle do
    cellar :any_skip_relocation
    sha256 "0fb61e7d24bf386d415a4b608d5f4b180cf752dc87043f0a84506bada85281c1" => :sierra
    sha256 "dfd93ee2481f2a88eb26bbe9e4f17b50c4b870210453da616b8b20f520f01c6f" => :el_capitan
    sha256 "2722ebb74b9321b0fd258f59f084d8394f20977f1bcc2872e55ae455fa37e361" => :yosemite
  end

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
