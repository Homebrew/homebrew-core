require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.8.0.tgz"
  sha256 "bb31c2a47b034cc461ec50681563f0ba285190da08f96ac19e7e97df4597ecff"

  bottle do
    cellar :any_skip_relocation
    sha256 "95778a0098c2ad6abf7c880a80a0f997dc08d9eced15cd544009b724856e8e7b" => :catalina
    sha256 "c60b2017b79ea5d9edcc01359bb0ac7e76f73e80ecb49d73727a3076d2776f42" => :mojave
    sha256 "ae6aa6090b13eff2cdc373b169fe7b691eb2a35b4665186eff04a0519ea4194e" => :high_sierra
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
