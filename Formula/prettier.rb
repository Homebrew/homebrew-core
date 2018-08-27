require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-1.14.2.tgz"
  sha256 "3c56975ca3646a1116e3b6d0ebe7713877c33042a45dc85ed0a5c9eda24df186"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d0ec44d3abc935bc534da37ed9ff51cbc84f3111947e2d257aba9b557a13c06" => :high_sierra
    sha256 "75b2d4224c4462640444c1705f55a6af03933e55868104099a5770fa6f02c159" => :sierra
    sha256 "b07cb331727ff353f90af1fa639ba0971127c08236365d4e55130e1c6f5fd044" => :el_capitan
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
