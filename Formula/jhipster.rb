require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.9.0.tgz"
  sha256 "3680e9eed0f33edaaa4cf4f1a123ae4c30ed161cd38dc5d9c044c219d9b0069a"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e0b435708167c28a21bac60887b64507fd2db29fc412a69d85feb686c4e14f1" => :catalina
    sha256 "f94776142c9ffabcf4cecc27fac83cadcaf8313a58c5760967072f6dbd435a8c" => :mojave
    sha256 "031f1a3abb0c2dcb1e303365281be4fc82f7a232404777cb7841ce4cf4aad558" => :high_sierra
  end

  depends_on "node"
  depends_on "openjdk"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", :JAVA_HOME => "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
