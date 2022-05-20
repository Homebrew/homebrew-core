require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-7.8.1.tgz"
  sha256 "c39921657dc50a106e0533229492915304b30a85d647e9a65788e19546ed4ed0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27c1b3541a20bdab8d9351401eabdf18548afebc85f94af1fa82dbe841d445ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27c1b3541a20bdab8d9351401eabdf18548afebc85f94af1fa82dbe841d445ba"
    sha256 cellar: :any_skip_relocation, monterey:       "f250319b1919080ce509ff83066ea2483fa6a8359627b6f722a7a9bcd45c8c54"
    sha256 cellar: :any_skip_relocation, big_sur:        "f250319b1919080ce509ff83066ea2483fa6a8359627b6f722a7a9bcd45c8c54"
    sha256 cellar: :any_skip_relocation, catalina:       "f250319b1919080ce509ff83066ea2483fa6a8359627b6f722a7a9bcd45c8c54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27c1b3541a20bdab8d9351401eabdf18548afebc85f94af1fa82dbe841d445ba"
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
