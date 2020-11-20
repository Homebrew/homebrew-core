require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-2.2.0.tgz"
  sha256 "45f36cf58d92794a881fde256102aab7fca78754a22370c1dcb4c91c8409a6e0"
  license "MIT"
  head "https://github.com/prettier/prettier.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "300017c5cb62272b854fa54bbf8b7386492523ec7e4a65745d4b310f4a1c2e66" => :big_sur
    sha256 "79ce2891788b513230cfa8c91fc5213ed0987fd44e0772cf5ccb5c7679f55c5f" => :catalina
    sha256 "af8508871ff64c9385e8a5e6163ab609bc33f32593ca883b6b65dfbdeed33d4f" => :mojave
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
