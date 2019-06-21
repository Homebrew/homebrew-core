require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.1.1.tgz"
  sha256 "712c6d40ed8e4ca6f0c86300a32ba097c4ff630e1b87929314c54d9f8660893f"

  bottle do
    cellar :any_skip_relocation
    sha256 "e86253e490894f9a4133d692ff678e0c43f9295aeb4ccf01722d5aad54c27bb6" => :mojave
    sha256 "bb53e8eeafe3167c0d067a29c6d182085d0608e7c068f51dcca08740aa1cbd26" => :high_sierra
    sha256 "5170693896299f4fe4fef038e7ce49a35f1a8d866bc6666cb15e9414bb888aba" => :sierra
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
