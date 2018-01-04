require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.13.2.tgz"
  sha256 "2cc51e08886ed82fc182d389501561603969925c958116a9204d2f16f6356fd5"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb156e94ad90ff55e7fecb0e8135d39e6febcf4565de5393296ccef7467360a6" => :high_sierra
    sha256 "bc3d07c7e6d4727c6c096f405558595724b186f37b026e34806f98b4e0fa0931" => :sierra
    sha256 "b8e7c6787624d3f3dc4206f3dc1ac7ee540fdf3720092501853ccd11ae5e099e" => :el_capitan
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
