require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.5.6.tgz"
  sha256 "4174da8fa76ca44fa210675b4176043aab1950020ff7195b3885f49cccadd457"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b8224d782ae9c6e3a8b78dc757454ed7aaaabf535a539f270f56e8534428d07" => :sierra
    sha256 "f0308be9f3f78e6daf591ece79282bce1650c01a83f9053cdae1621385e1769d" => :el_capitan
    sha256 "c32ad80902c46ef843d64cccf79d434a3af72b2fa41397f98bd9852f3c6ff740" => :yosemite
  end

  depends_on "node"
  depends_on "yarn"
  depends_on :java => "1.8+"

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
