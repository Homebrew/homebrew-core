require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-2.0.2.tgz"
  sha256 "c2052c741c20158a41dd871687081ad8f85dc41364ab0b4a57cb55f61d8b1484"
  head "https://github.com/prettier/prettier.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eaf8a28b352b700dd50fc7a474e95433f59cd9e9f42671c2d9c099f331b8f658" => :catalina
    sha256 "392d5e6ded1a2662c6531ea6984a76b122e17767e4f28423f8f7db71a3bc9816" => :mojave
    sha256 "1618556927d9a4a0303fa6a464433079eaba3a6561bc8398d43490d8840ee08d" => :high_sierra
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
