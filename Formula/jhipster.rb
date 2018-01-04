require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.13.2.tgz"
  sha256 "2cc51e08886ed82fc182d389501561603969925c958116a9204d2f16f6356fd5"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ef601dad359d0785e23ce9cd47a461f806065a205816c120f47e372d06109f8" => :high_sierra
    sha256 "f404baf72d21375b1fc9429c604a8d4e2060978a7097da6d52e22033a6e8cb5b" => :sierra
    sha256 "335d2b256f89fd63c0359d393da9078ef605b684235ec1554dde5d7649a5f924" => :el_capitan
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
