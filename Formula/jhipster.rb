require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.5.5.tgz"
  sha256 "f31f37594211b45206dc907937100875b0022733341c75b2ab6fefd35cec97ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e2a4ad17e5bbbb8dde194f0530cb6fef18888f9240984a995b0c59a8e999442" => :sierra
    sha256 "0d578a9677065b0559a5860f66ac556deee7925a51a247c48c31eec47651b77d" => :el_capitan
    sha256 "2a93a3304e791c498ad3663feba8508a947d0dd8313672e0dfcd2c3dabd299b3" => :yosemite
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
