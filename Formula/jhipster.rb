require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-5.4.0.tgz"
  sha256 "fa0fb732735c155c66199cdfea2a030feb8b7c5af2e240e4448a31521caf090d"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a4f96e9669867257db44244b40b64a3bddae5aca02874c7ab60d02af1fdcf58" => :mojave
    sha256 "e1b1e785747a0387eda139553acd91d3f73097d01d7db68d96e8400654e9c33b" => :high_sierra
    sha256 "c10c550b67684b61291a26bfe5480f32bbb5953f93415f197e2118254ec1dcd7" => :sierra
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
