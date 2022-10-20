require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-7.9.2.tgz"
  sha256 "5f089544d6c2f06bbd109d06460ff6f2387b10d4c8fe9a54d4be070a00779b56"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6470523be77560242b755bc18af0b91479daea4e60e68409c9a286a6fef4ae2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6470523be77560242b755bc18af0b91479daea4e60e68409c9a286a6fef4ae2"
    sha256 cellar: :any_skip_relocation, monterey:       "960ac782a7603c74b684a76fa5288014246ef71817fe05c5d267cbb1d94bc146"
    sha256 cellar: :any_skip_relocation, big_sur:        "960ac782a7603c74b684a76fa5288014246ef71817fe05c5d267cbb1d94bc146"
    sha256 cellar: :any_skip_relocation, catalina:       "960ac782a7603c74b684a76fa5288014246ef71817fe05c5d267cbb1d94bc146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6470523be77560242b755bc18af0b91479daea4e60e68409c9a286a6fef4ae2"
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
