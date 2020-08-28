require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.10.1.tgz"
  sha256 "65304b03bb52f8a7501e4074475b386c8c6e57692e30c878f49335e1d1dd9afd"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "38a2e2638327d322920c5cb5fd313136503b631feb8d2323b6ba00e94ec923b6" => :catalina
    sha256 "2b7df8fe1e3be086f918ae64a33d8788ce33bc5451201a37ecc23c80481733fd" => :mojave
    sha256 "6173eac8ff0124943df1b9fda1b8de631f747ee5d53c5088b32a0ea74e2752bf" => :high_sierra
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
