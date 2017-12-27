require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.13.1.tgz"
  sha256 "078115b8d3a5bd4eade0dcd8c3e3fa09d45ca244b68ed44379ca8f2fb503ca69"

  bottle do
    cellar :any_skip_relocation
    sha256 "9389d0ecb0ec8c5724afed311235b7b6f1f70bccf3db19d03f69056c8b4febd0" => :high_sierra
    sha256 "d11c73efe2db9a9347465bc19cecdc04b0ba110d4e4db9c7fb823b64eaa0ffbc" => :sierra
    sha256 "6f714710d6189b9487680cef7058411ea0d8688af45a21e17b69774ae8e81be7" => :el_capitan
  end

  depends_on "node"
  depends_on "yarn"
  depends_on :java => "1.8+"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
