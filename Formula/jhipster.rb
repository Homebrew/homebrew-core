require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-7.9.0.tgz"
  sha256 "ac8a8f5a5f357402047425f55801fd59c2498cd7d3bacd75d8b9bbda296de18e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "207f36c6c083f6b950f705b870e313126b33a13c33b1cb32621b143579e4ff87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "207f36c6c083f6b950f705b870e313126b33a13c33b1cb32621b143579e4ff87"
    sha256 cellar: :any_skip_relocation, monterey:       "14859d3f33154eed635700a18b2547eb58aaf7f69accfb5f9873fb314d5bd2eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "14859d3f33154eed635700a18b2547eb58aaf7f69accfb5f9873fb314d5bd2eb"
    sha256 cellar: :any_skip_relocation, catalina:       "14859d3f33154eed635700a18b2547eb58aaf7f69accfb5f9873fb314d5bd2eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "207f36c6c083f6b950f705b870e313126b33a13c33b1cb32621b143579e4ff87"
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
