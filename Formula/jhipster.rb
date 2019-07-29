require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.1.2.tgz"
  sha256 "bf4671eb9d194c4f83c81d7da72cdd31781ab6f5d53c7e8bc25dd7cdbcbf6ead"

  bottle do
    cellar :any_skip_relocation
    sha256 "5255e042e852c9d3ab51564ca62fdaad37202ccd4b0bfc1a2b35ded1424dc7a5" => :mojave
    sha256 "4f2d350dcbf6193959995c949d15e0286d2d7f75ee4433f691af47c02953bb21" => :high_sierra
    sha256 "9fbb06f6ee2cc89a20ad8358560c12ab809505f0e4f942c09d7e7014b5195927" => :sierra
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
