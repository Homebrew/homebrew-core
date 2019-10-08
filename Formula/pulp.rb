require "language/node"

class Pulp < Formula
  desc "Build tool for PureScript projects"
  homepage "https://github.com/bodil/pulp"
  url "https://registry.npmjs.org/pulp/-/pulp-13.0.0.tgz"
  sha256 "91b5e517afffc8f53ed6dc608eef908bd92843ce73976acf57db6eca897b5ba0"

  bottle do
    cellar :any_skip_relocation
    sha256 "31f201012bb920b2716f47a48bbf6a762e88c7ba5587e1bcf206b0420c12324a" => :mojave
    sha256 "14503036a125c1bda8fb419d7b35ce7a9de7314b74893f6726c4cd726f611b0a" => :high_sierra
    sha256 "f565ef1a1cd9235139f52d968b09c1d5dc17dddf015efe7d9b68cf9f644b0135" => :sierra
  end

  depends_on "bower"
  depends_on "node"
  depends_on "purescript"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulp --version")

    system("#{bin}/pulp init")
    assert_predicate testpath/".gitignore", :exist?
    assert_predicate testpath/"bower.json", :exist?
  end
end
