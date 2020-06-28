require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.10.0.tgz"
  sha256 "c770d91e4157a9479113c71d78249901f1ab2bf68ba1c949b1d6ddad0930ef99"

  bottle do
    cellar :any_skip_relocation
    sha256 "0370221b4757cdf987f7226562b964fdc66ad4cebdbe9d2c494f0fb58133584a" => :catalina
    sha256 "b37804904b64199f8767e2564e6b5b2f553c4c68716e8c5eb79553909abf3f6b" => :mojave
    sha256 "daeadf9190782a2f0ea4aae27ba345d75e4be28f76b03681b309a7f52541d09f" => :high_sierra
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
