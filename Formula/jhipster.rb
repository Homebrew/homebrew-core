require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.10.5.tgz"
  sha256 "3d6ac98e1e777f9f7a33a21a01f4f181a8d9252acb46003a0e850fb8c62bc918"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c35178d2999dafde1782be1ce343c52a83b9c5d98c547a9b69318e12c6883ffc" => :catalina
    sha256 "ac31ac32a75c9455c7e3530fb0b0fb57bacbdb7ab675079757db0e1b541e8d84" => :mojave
    sha256 "7ef414f012ef8a91a4f449423df522a14598f6e1728265ab48ede61b2e41e5c3" => :high_sierra
  end

  depends_on "node"
  depends_on "openjdk"

  def install
    mkdir_p libexec/"lib"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
