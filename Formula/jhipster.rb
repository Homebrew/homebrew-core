require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.14.3.tgz"
  sha256 "e38c4191caf58d8be93c14c9161cc4aea99ddf4e177d04e011c39cac037f506c"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f427f8454aea435bc27a321a8d6ed35cdd8471eab437eca831432a18ca6573e" => :high_sierra
    sha256 "9ee59e57cb4af03637366ca43a7b02a8d261a9e31c85c40788c896946d3131f7" => :sierra
    sha256 "a1255ac7e51d52a783a0770661af654abe105eddbcb8a1524110dfd8cb569120" => :el_capitan
  end

  depends_on "node"
  depends_on "yarn"
  depends_on :java => "1.8+"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
