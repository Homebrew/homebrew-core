require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.4.1.tgz"
  sha256 "9e83e7644d6aa72e56953771d70428067cf3567ffc43c941015e2417036140f7"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac4fddfac50138c831e3712ab13ee6de3d2fb25e367c58a79ca709f4a7df60da" => :catalina
    sha256 "5dd7c02c70abafdfa6c748ef409793c7814d41669f904bae45efbf777b904cd1" => :mojave
    sha256 "12369e444cbe78163eac38115ab60f0cbe619ceb5e1aef64eabf834b718715c4" => :high_sierra
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
