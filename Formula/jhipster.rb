require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-5.6.1.tgz"
  sha256 "cb697517793d22aafc515fc8fcea256b59319e242325ccf38e52e35418d9d807"

  bottle do
    cellar :any_skip_relocation
    sha256 "d58ea9dde588b2bafb9cca507ba1887b3aeb085e0e655c5d091ff5f2ab6869e5" => :mojave
    sha256 "ae5407096655876d28f8d72ab3ef205644c393d78efcdd47bc0d55bbc1b7733e" => :high_sierra
    sha256 "1d9839279a6a161ab9e9f6e76d84ee9eda87a48163c0fe512047268b88da0093" => :sierra
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
