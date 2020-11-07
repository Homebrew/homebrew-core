require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.10.5.tgz"
  sha256 "3d6ac98e1e777f9f7a33a21a01f4f181a8d9252acb46003a0e850fb8c62bc918"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "09d757c1dc23d3b53d0b7af93ade3b1dc8e38fd04933db0d10dbec3e127a9b98" => :catalina
    sha256 "10c1f95358496627f2bf5191f36b39524388c520b8c1a7b04d093a3ed7f328dd" => :mojave
    sha256 "9c2f738cd4a0092a8089ac91e85b5c67f4349370a79fa598148fbe286672a09d" => :high_sierra
  end

  depends_on "node"
  depends_on "openjdk"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
