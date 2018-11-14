require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-1.15.2.tgz"
  sha256 "3464dce04d7a9e9f4dd35c1390ed107afb8c43c2b32efecc25337cc4fa2383c0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e4a2211d03f015572fcd666195c3c19d7837bbc40e121053b8a52197d5fa638" => :mojave
    sha256 "f9e155b58930c66d1661eae87524f36d914a1e37db5efcdb39e2056863124e6f" => :high_sierra
    sha256 "db328a0adbd2977252018eddd49b98dbd1525148fd2f484bb04204101a67eede" => :sierra
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
