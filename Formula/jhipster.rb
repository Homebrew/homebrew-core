require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  # Check if this can be switched to the newest `node` at version bump
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-7.8.0.tgz"
  sha256 "dd2541bb26cc1976e7334d8e6a80d0fafcc604b859b663b4640c18a4eb08b6ca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1762f57c8cdcd3575ecab96f08f07ec86d33283696188f91033321d1528de51c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1762f57c8cdcd3575ecab96f08f07ec86d33283696188f91033321d1528de51c"
    sha256 cellar: :any_skip_relocation, monterey:       "44bed5b853f8545d3fb664c3df44fc8863c4c630b3d31257ffc13b6ffa1c49f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "44bed5b853f8545d3fb664c3df44fc8863c4c630b3d31257ffc13b6ffa1c49f0"
    sha256 cellar: :any_skip_relocation, catalina:       "44bed5b853f8545d3fb664c3df44fc8863c4c630b3d31257ffc13b6ffa1c49f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1762f57c8cdcd3575ecab96f08f07ec86d33283696188f91033321d1528de51c"
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
