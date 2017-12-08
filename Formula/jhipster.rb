require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.12.0.tgz"
  sha256 "1b418e384d76380278d451933434ea8d9bac3005770b6a136345c135013d819e"

  bottle do
    cellar :any_skip_relocation
    sha256 "519503b30691b7db49d82598dbb639fc27935de891831f73a40bbb1e5d495eb8" => :high_sierra
    sha256 "8a7440c088d6a77c038cb828ec3ae08b6e8b85a77e6a79ea80ee6c7ecd015f5f" => :sierra
    sha256 "ba8ceb64ee111c41cf6b3a2f6c2f9ffe7c8b2fe4de3a6107b5551057ee3801de" => :el_capitan
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
