require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.10.4.tgz"
  sha256 "236b290b1fe762da1761a50f8df521a2d45466f94315039f85e3c7f946f95b9e"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2b1e8ae95a7926b1e78790f7735c4cacd6c631a806d6c1585db36d36f706d3cb" => :catalina
    sha256 "d7bfdb83872bb3422a5fdd11ad9f4046dc84d6764a09687893246176d55b4381" => :mojave
    sha256 "a4dcacb4539ff11137b39071eff111b0965e10fde63c3d8f9f9280475934c309" => :high_sierra
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
