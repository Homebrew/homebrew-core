require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.6.0.tgz"
  sha256 "5b8a66a5b8a2503dcec9302ea0d6151f08b0962e7652b50867defbb95a3c975c"

  bottle do
    cellar :any_skip_relocation
    sha256 "19e835ba4b309981f52e06b0c6051bcfa23100784283057d05417459129e61f0" => :catalina
    sha256 "a67bb5b581e8c0984534ccc24d8b54a86a1ec742dc6495a99a4137cfa6e6a5a4" => :mojave
    sha256 "b469d005b1d685772aa4b2b65e1ae3b6ca0b917380fc5e7d669577f79ab71fcf" => :high_sierra
  end

  depends_on :java => "1.8+"
  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
