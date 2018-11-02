require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-5.6.0.tgz"
  sha256 "7f339523c41b01171303fe1488af49dc72dfdee18011440e866b1030969d2728"

  bottle do
    cellar :any_skip_relocation
    sha256 "459c74f3c4e3ec24866b6e3e12e7fa23546c66b75f8921a2e5ac714739274fd7" => :mojave
    sha256 "0b7bdfcd8c2d6a15e951d05b6812e09153005d9e046155d9c12e311466bc5fc6" => :high_sierra
    sha256 "ad6263b22be9da7d869716be21b0be5f5cdbb69cd38c0f53a416dd39c17acbab" => :sierra
  end

  depends_on :java => "1.8+"
  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
