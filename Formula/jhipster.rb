require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  # Check if this can be switched to the newest `node` at version bump
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-7.8.0.tgz"
  sha256 "dd2541bb26cc1976e7334d8e6a80d0fafcc604b859b663b4640c18a4eb08b6ca"
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
