require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.6.2.tgz"
  sha256 "e8d75e5479b3bbb7c3ae7b91464b4ffc5bbd8bf804b104a3a5df72f12ae92c2e"

  bottle do
    cellar :any_skip_relocation
    sha256 "f053c31a00ead079ce276d865a43f2f6cf23e9d54ab74cf8f735f6e7e4b38ca5" => :sierra
    sha256 "6d7cd44f83a7ba9d1f1ebe7c8e4b574346336ba918c5588149b682a4bd41de2c" => :el_capitan
    sha256 "bd3eca78951025f78eec7ea08fbe717293d0579990832959624ac2dc7017ada6" => :yosemite
  end

  depends_on "node"
  depends_on "yarn"
  depends_on :java => "1.8+"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Execution complete", shell_output("#{bin}/jhipster info")
  end
end
