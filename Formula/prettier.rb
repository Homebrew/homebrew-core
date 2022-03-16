require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-2.6.0.tgz"
  sha256 "4934fb047ef4ad2a8e89336e3601088a7dba4c536539921c3fd3d7322e6e0adf"
  license "MIT"
  head "https://github.com/prettier/prettier.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b226eeb3f448795140ca2339340b2adc0d67b84b571c0b372642d9539ec0189"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b226eeb3f448795140ca2339340b2adc0d67b84b571c0b372642d9539ec0189"
    sha256 cellar: :any_skip_relocation, monterey:       "c1250d366af6a799659dee93c22beeca6f8526d98a1903a03429cd20bb601206"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1250d366af6a799659dee93c22beeca6f8526d98a1903a03429cd20bb601206"
    sha256 cellar: :any_skip_relocation, catalina:       "c1250d366af6a799659dee93c22beeca6f8526d98a1903a03429cd20bb601206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b226eeb3f448795140ca2339340b2adc0d67b84b571c0b372642d9539ec0189"
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
