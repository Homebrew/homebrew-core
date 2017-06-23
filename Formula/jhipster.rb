require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.5.6.tgz"
  sha256 "4174da8fa76ca44fa210675b4176043aab1950020ff7195b3885f49cccadd457"

  bottle do
    cellar :any_skip_relocation
    sha256 "bba2fe7e6990bfdf6398c11183d4de0319081302c17f1c6534e63d0537da406e" => :sierra
    sha256 "a53d6d0d56e80b2e33534d733dd591cccf8c9eaa362bdd519378a1ad1630fbc6" => :el_capitan
    sha256 "2db57cb5404bb5d0e52a5812780dc96704e7b74a88940645b0bb6de14dea6099" => :yosemite
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
