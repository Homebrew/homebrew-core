class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-8.7.1.tgz"
  sha256 "6b6d4e91590bceb0f49312deb75a74a9a29c0b41fdfec1a0d23451601ba7531c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d305914cb0856d3a782b5c4bf55c9a32568a962e11c966e08f4cb12e5721ddee"
    sha256 cellar: :any,                 arm64_sonoma:  "d305914cb0856d3a782b5c4bf55c9a32568a962e11c966e08f4cb12e5721ddee"
    sha256 cellar: :any,                 arm64_ventura: "d305914cb0856d3a782b5c4bf55c9a32568a962e11c966e08f4cb12e5721ddee"
    sha256 cellar: :any,                 sonoma:        "fd60447fc7e918f074dff3993aef794e4eacb9a6ec0d46ffd6753034a533a39c"
    sha256 cellar: :any,                 ventura:       "fd60447fc7e918f074dff3993aef794e4eacb9a6ec0d46ffd6753034a533a39c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "221204f79cf52314e5eba7204f5bb738db7e93817bb40be359338c4cefa65696"
  end

  depends_on "node"
  depends_on "openjdk"

  def install
    system "npm", "install", *std_npm_args
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    output = shell_output("#{bin}/jhipster info 2>&1")
    assert_match "JHipster configuration not found", output
    assert_match "execution is complete", output

    assert_match version.to_s, shell_output("#{bin}/jhipster --version")
  end
end
