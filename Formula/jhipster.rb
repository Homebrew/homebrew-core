require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.5.3.tgz"
  sha256 "f307d9e009a9b28d332daf16c88cf0659ad73582d110a1d52c07aaa5b3c90df9"

  bottle do
    cellar :any_skip_relocation
    sha256 "7cc9ebe7529c05dc544f78b7719e5f41bd2fb2f3812c832b28756fba1ea47edf" => :sierra
    sha256 "c3e938629196d2183a7bce117f4b36ef95853092d360976d176045ae7dd35084" => :el_capitan
    sha256 "f31b59ffbf574dbabd08a4ac4a8a0d1d832516429f72f200642fdd6d6e5dc534" => :yosemite
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
