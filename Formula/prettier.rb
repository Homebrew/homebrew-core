require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-1.18.0.tgz"
  sha256 "d8da7d7f657184861ae086e735851af6d93d6bc3e7197b973f854198f3a13866"
  head "https://github.com/prettier/prettier.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c29820b3cb6196f65c6f53e87c7b44429bdcf221015d0313d700096bbac4efd" => :mojave
    sha256 "f02e70333a83a9cb8638ee52d9a1b1a7f45aa7b269a3217e1acb476e2834225d" => :high_sierra
    sha256 "aa218d17a5d42f21995cc88023aa932baa0650fb5b69ae08d3d379ea65e05547" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    output = shell_output("#{bin}/prettier test.js")
    assert_equal "const arr = [1, 2];", output.chomp
  end
end
