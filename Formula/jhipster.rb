require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-5.0.2.tgz"
  sha256 "d60b44bbc386c51c586bd7b0ae9a1d545f0000f76009a3b5d7dfa6403c53b975"

  bottle do
    cellar :any_skip_relocation
    sha256 "7570dc7cf3ae924bd66f7c9ddb805e670abdc51ec20067fd5f6c9416e4fd334f" => :high_sierra
    sha256 "f12c127f79861c9405e07bc36da61ffaec60fcfc9116d4125c52e21b99e88340" => :sierra
    sha256 "1afbddb09390f2f2327463c53540e0fba9733dd8dd6852ae190f76c735e411aa" => :el_capitan
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
