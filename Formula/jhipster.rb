require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-5.7.0.tgz"
  sha256 "061ac31ed20c8c06cdb72a5806eb7e2da05f5500bd591c6d842a79a5e4432d53"

  bottle do
    cellar :any_skip_relocation
    sha256 "52c39dea01bcc2fd2e768026beaccfcfce91620ca73ae2d1e9489ee79e28bc1a" => :mojave
    sha256 "c5fd2d9b9f958fda8b0156072e4d57c3ed20c33f691362662042118ef45f8979" => :high_sierra
    sha256 "aacfa6293c451259c76feffd45c7e1e9ef2ab7c509553a02f5bbadac9daefb2b" => :sierra
  end

  depends_on :java => "1.8+"
  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
