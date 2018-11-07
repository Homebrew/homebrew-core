require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-1.15.1.tgz"
  sha256 "e15159deb7c47c0b660059ff3947d18d5ce66733effe119d980c23bbd797ec07"

  bottle do
    cellar :any_skip_relocation
    sha256 "5fef5abde00e5b6c1c4647f5a37e66618c2e6117d8a47e01e7e591064996f158" => :mojave
    sha256 "49d81e2d36fd8d662a8b7f1eac8580fe705fab16daaf3c19cdf84ba5366dcea2" => :high_sierra
    sha256 "8f2446d1a727c56fe3df212c34481ce298f3101f714f752f472bff147310a98f" => :sierra
    sha256 "a0b468ee5bb4f5462f7d6f791c825396158fadbba20ccc8489e784d234398cfb" => :el_capitan
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
