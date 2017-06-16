require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.5.4.tgz"
  sha256 "3e1baf284d514d490715e3c5aaa1920ea089992f0b17864209e00ddd7880e645"

  bottle do
    cellar :any_skip_relocation
    sha256 "264d3018112bdc639e474939cd3d037f21d576558c446fd1a21a36d5b94c1877" => :sierra
    sha256 "013bfd96f96853b3f9f83294fe1a2f5a84bec859dac8bc89e3485894dcbd35cc" => :el_capitan
    sha256 "c1c708502a243c59447e94d6bee3a1ab9bf5e42f6369e271255edd62582744f7" => :yosemite
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
