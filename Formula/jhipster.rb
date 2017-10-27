require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular applications"
  homepage "https://jhipster.github.io/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-4.10.2.tgz"
  sha256 "e8f3af5db3c035e7258a9293dca20f3e4334c942c296c2951cbb0a7c3af25553"

  bottle do
    cellar :any_skip_relocation
    sha256 "d23e0d5c41248251629ed7f169b5cdbfe726fac20d1c43e91ebb34a4df3bf98c" => :high_sierra
    sha256 "31a1225953420daff84c15cfcb116969706fd69ab30c91273befef90448cc320" => :sierra
    sha256 "0291cdf22bb68dd8f33c50f805ecfd83ae0a54dcde6388a79530be4a2e3c752d" => :el_capitan
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
