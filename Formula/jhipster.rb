require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.11.0.tgz"
  sha256 "26bf24c40f0f94493123e83be17c8b6b560b3ed992fe0324c042dcb90acd441b"

  bottle do
    cellar :any_skip_relocation
    sha256 "02e0d4c96d4d774a1acfa43e1ceec573694e703154a1f5bd95f5e687de876684" => :high_sierra
    sha256 "8469af65a247074c267efa61cd0be1e809ee63dcfd40537375df87b705e3b4de" => :sierra
    sha256 "0e3f12abee8fb684f9b763b6d1c348b8eb474f8fc300c3e10ee5645534d47f3f" => :el_capitan
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
