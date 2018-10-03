require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-5.4.0.tgz"
  sha256 "fa0fb732735c155c66199cdfea2a030feb8b7c5af2e240e4448a31521caf090d"

  bottle do
    cellar :any_skip_relocation
    sha256 "c528d539237c8d706b4567ebefcd435608b723be255034e966e2c4f05b89833b" => :mojave
    sha256 "ef719df22e4140a910f1c9dff30d8c8013d69eeedb2b42cb0158d2983319edd4" => :high_sierra
    sha256 "9d6e6f68aeddee91780049efccc1fcab6a7258306dcddb512a849122d7a428ec" => :sierra
    sha256 "d50b220d338cdd1412a4ff0aea1d89bed027f7fdb82e93892f4f8bec605fa600" => :el_capitan
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
