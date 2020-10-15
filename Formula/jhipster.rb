require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.10.3.tgz"
  sha256 "24474dd9524ff6dcc13152563f54b94b31514e38c1a6743e45ad6f4ad470c5d2"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9ffb08f0b190da3ea8e7ca1855f45cc58eac230ef29957b9c6c4f108a1646be5" => :catalina
    sha256 "2d6eb5f9d15afe63dfdbea05ed2f9ae544718ef46ad22a6a394d42253948112e" => :mojave
    sha256 "71f172f6214a7b0218137bd85575dcaff1dfeb5ef39da013a7523889c71a4541" => :high_sierra
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
