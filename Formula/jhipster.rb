require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.6.0.tgz"
  sha256 "5ce978ecb0ef3e5321e2a55975d2255939d1bd9059f3ccc190f554294ca2a1fd"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4bb2db8d2c29bb825930acc909e6580fc7ebd95dc05d46f0bdd4294b04287ac" => :sierra
    sha256 "c7c2784442837c30d904a6cbb0733603b86945656a101055ccdd956f7f584261" => :el_capitan
    sha256 "fd72fb560a5a4ceaca708ae1cc33654c7c7fa1218a6b5f753f61f089db7bd037" => :yosemite
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
