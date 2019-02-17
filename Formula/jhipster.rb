require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-5.8.1.tgz"
  sha256 "8ff083a66b913ec23d99eded9b3b16770e6a94f770af39efeb85e8206d387eb6"

  bottle do
    cellar :any_skip_relocation
    sha256 "d48e4b2371d78edacd0e1b4b57c420924f6c2b8be2ba21ea160908edbcc2e9e5" => :mojave
    sha256 "efa2e8f223e0e1c348c7e4e5c35c08edde66e90bf8808dff88599ea3cd6a3093" => :high_sierra
    sha256 "af8c42aba6252523b1e73092a3822181a5f3d97a2f0a473bdfaca56e6ea948fd" => :sierra
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
