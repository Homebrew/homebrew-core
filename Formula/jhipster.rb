require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.10.1.tgz"
  sha256 "65304b03bb52f8a7501e4074475b386c8c6e57692e30c878f49335e1d1dd9afd"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c5827dea68f174ed0178d92b74a7fcd298bb10bec9a9aa2d89aba24ca17bae1" => :catalina
    sha256 "1a0def967d83fc1b19a5a9b1886eb8b205db4591c21a764edc26106f7b2d859d" => :mojave
    sha256 "ba0619071d3f6a43ddb33faa25b06af8e0eef3b2c8d3593a3ca95a111b08d47e" => :high_sierra
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
