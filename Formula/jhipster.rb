require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.6.0.tgz"
  sha256 "5b8a66a5b8a2503dcec9302ea0d6151f08b0962e7652b50867defbb95a3c975c"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ca32c43b06bc75f89c6158977704e0bb6dc0e22525313680c4f7c102b8b20f1" => :catalina
    sha256 "21c3bb63f656d16b5ad18c127476f95c6c75595d41dd7d1be8f2e5b48c7b6b3d" => :mojave
    sha256 "c93c20e1f2c84877115cfc210a5d77daa17182326f1747772d324ce2911b2793" => :high_sierra
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
