require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.7.1.tgz"
  sha256 "e0d6e90f9e296eac9bb8fd7ad22c162c50be1ac19a02e5aa98092785ef9ba3f2"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "f04b0fc5f4af5815f47580c2b14e59e22cd69e0e15ae1f8fb471cfeb1bc17eff" => :catalina
    sha256 "5e144a653d8c74248b652434d39091215daf80a4a623caf0a2accccd0544316d" => :mojave
    sha256 "fe1ba856f9c75f7ab9d155c7932924455b7a332dd687a322630754c137678719" => :high_sierra
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
