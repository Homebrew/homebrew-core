require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-5.1.0.tgz"
  sha256 "c35886b708e03f85dccd505d4c974c47b4958f49358a086dc038cf21695d50bc"

  bottle do
    cellar :any_skip_relocation
    sha256 "6591388346915e821f3525be58a4fa17474271cf8476d0a1225f798878449338" => :high_sierra
    sha256 "ca0700930bccacad19b344dccd67066605d5296f86126ebff8a93bb8f709b6f6" => :sierra
    sha256 "99de8e6833eb8b51d2f27657111aa3e381200d4494a33a31cc159667c8e38549" => :el_capitan
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
