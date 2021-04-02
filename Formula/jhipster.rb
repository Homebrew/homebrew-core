require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-7.0.1.tgz"
  sha256 "5e92b04561905adee9e91e4f2f8f12dd93d5ab389556753e09ee23fe34035873"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "edf9a4827d0ba3e318dcdbe37e691d1dae0f9a83d74ee2aae58184934b6ce2e8"
    sha256 cellar: :any_skip_relocation, big_sur:       "383a62d2521975cde135e326f678ea3b636271bdad39f6b36c53e261d5e413ad"
    sha256 cellar: :any_skip_relocation, catalina:      "d18017c4fb21fc3076b0360372f9ff8e14260399f00caddd948ef3220fa77f78"
    sha256 cellar: :any_skip_relocation, mojave:        "a5f8fcb7dfd53f388d8866976fb296a4772bd8d6ef5b751bc9344fe75e73c189"
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
