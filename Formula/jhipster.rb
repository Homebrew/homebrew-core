require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-7.8.1.tgz"
  sha256 "c39921657dc50a106e0533229492915304b30a85d647e9a65788e19546ed4ed0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f786c4c114b2c52d0dac6f504926815d431902a52d0c11b42329d7fd1c07fa5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f786c4c114b2c52d0dac6f504926815d431902a52d0c11b42329d7fd1c07fa5"
    sha256 cellar: :any_skip_relocation, monterey:       "c0220a45f0195d13cd5fc15a172b2f5b85bab9ba4d4c393f7fa3e13d1f774ea8"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0220a45f0195d13cd5fc15a172b2f5b85bab9ba4d4c393f7fa3e13d1f774ea8"
    sha256 cellar: :any_skip_relocation, catalina:       "c0220a45f0195d13cd5fc15a172b2f5b85bab9ba4d4c393f7fa3e13d1f774ea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f786c4c114b2c52d0dac6f504926815d431902a52d0c11b42329d7fd1c07fa5"
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
