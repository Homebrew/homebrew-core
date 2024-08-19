class Graphqlviz < Formula
  desc "GraphQL Server schema visualizer"
  homepage "https://github.com/sheerun/graphqlviz"
  url "https://registry.npmjs.org/graphqlviz/-/graphqlviz-4.0.1.tgz"
  sha256 "1ede0553fe61ca6f59876b31a7d86f8f9aa692456255c1acf91c204feb2e1ef3"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "826441385e304866c5a59798740b8b40a43f07692e19282b1ee4feb446e7cd9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "826441385e304866c5a59798740b8b40a43f07692e19282b1ee4feb446e7cd9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "826441385e304866c5a59798740b8b40a43f07692e19282b1ee4feb446e7cd9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "826441385e304866c5a59798740b8b40a43f07692e19282b1ee4feb446e7cd9d"
    sha256 cellar: :any_skip_relocation, ventura:        "826441385e304866c5a59798740b8b40a43f07692e19282b1ee4feb446e7cd9d"
    sha256 cellar: :any_skip_relocation, monterey:       "826441385e304866c5a59798740b8b40a43f07692e19282b1ee4feb446e7cd9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d37c65f45fb8a2db41b90fa7c502c6b749c3ce2f9e67ebb102ddfa8efbefe59"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_file = testpath/"test.graphql"
    test_file.write <<~EOS
      type Query {
        hello: String
      }
    EOS

    output = pipe_output(bin/"graphqlviz", test_file.read)
    assert_match "digraph erd", output
    assert_match version.to_s, shell_output("#{bin}/graphqlviz --version")
  end
end
