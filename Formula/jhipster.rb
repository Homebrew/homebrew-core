require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.8.0.tgz"
  sha256 "bb31c2a47b034cc461ec50681563f0ba285190da08f96ac19e7e97df4597ecff"

  bottle do
    cellar :any_skip_relocation
    sha256 "75202b214656405410e392f75651741b088144fb4ba01c8b8788f846be610469" => :catalina
    sha256 "d4913b32a8086583944adc44bdc0850861571bde791c6abcf2dd82322b320250" => :mojave
    sha256 "e9219e93fb75c10e8c491370ce7693d660d7e6d60983d49e1936bf125568762e" => :high_sierra
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
