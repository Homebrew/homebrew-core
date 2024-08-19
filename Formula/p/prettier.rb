class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-3.3.3.tgz"
  sha256 "2f1ecb0ab57a588e0d4d40d3d45239e71ebd8f0190199d0d3f87fe2283639f46"
  license "MIT"
  head "https://github.com/prettier/prettier.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca3d2129d7f7037e29ab41c3cdd7e6d160491f3a1cde78232f8cca9da9866518"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca3d2129d7f7037e29ab41c3cdd7e6d160491f3a1cde78232f8cca9da9866518"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca3d2129d7f7037e29ab41c3cdd7e6d160491f3a1cde78232f8cca9da9866518"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca3d2129d7f7037e29ab41c3cdd7e6d160491f3a1cde78232f8cca9da9866518"
    sha256 cellar: :any_skip_relocation, ventura:        "ca3d2129d7f7037e29ab41c3cdd7e6d160491f3a1cde78232f8cca9da9866518"
    sha256 cellar: :any_skip_relocation, monterey:       "ca3d2129d7f7037e29ab41c3cdd7e6d160491f3a1cde78232f8cca9da9866518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4eb20137d0bb94eb30df609bd7b942c4346f5e09aac867d6a11e3b2b2197d65"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    output = shell_output("#{bin}/prettier test.js")
    assert_equal "const arr = [1, 2];", output.chomp
  end
end
