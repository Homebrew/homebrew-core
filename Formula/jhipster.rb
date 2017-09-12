require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.8.0.tgz"
  sha256 "26a5061c681aae0336702ca01c8781d5f86e73e6e1cbb207a1876611c86f0c09"

  bottle do
    cellar :any_skip_relocation
    sha256 "80e1dc7771b4557d8496dc33a8ea8fa7f9aaeeb7947fb6bf12b2834e711f3338" => :sierra
    sha256 "15ba04d3b33706badf4816de8a46bc9561602576b5d91510ddea89bbe9cb2d30" => :el_capitan
  end

  depends_on "node"
  depends_on "yarn"
  depends_on :java => "1.8+"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Execution complete", shell_output("#{bin}/jhipster info")
  end
end
