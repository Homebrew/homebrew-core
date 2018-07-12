require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-5.1.0.tgz"
  sha256 "c35886b708e03f85dccd505d4c974c47b4958f49358a086dc038cf21695d50bc"

  bottle do
    cellar :any_skip_relocation
    sha256 "eddc8522f103e320fcbb8efdaf3791f50d5a7087776f6ca72d7964898c7fcdc9" => :high_sierra
    sha256 "84b190a949b8473ea8f43d45e72e268da4908eb0d84bd1f23fa49edd3cf8376a" => :sierra
    sha256 "fa31bda34044d9d9787725f99f71e24a1cccbc223d9c04bb8d98ff4773272a6b" => :el_capitan
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
