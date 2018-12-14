require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-5.7.1.tgz"
  sha256 "3927a5ec7c6f1a3e63a162a99d7a34c9eaa6fdb29f97edb2b28e40cb8154ad70"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a6a82cba443ac3abc6b57d0e7c0055aa8b938a6c508867c4cd104becead50b7" => :mojave
    sha256 "5055349323ea25e90b01077f7825380dd415b2a58fac3d9cd84fedb9a12be684" => :high_sierra
    sha256 "abdbb137157b80b04e4356a44bccef46ad5fe596da03de8df537f3ec683560b4" => :sierra
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
