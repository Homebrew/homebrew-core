require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.366.tgz"
  sha256 "c164630086ef093305dd30ceefc50af1b83c349210f5a15606afac74fb038700"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2bc411bf8b20c4e116aaef77da5b5d5bbc9187e1d7943723fe8c9e5f77d978c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bc411bf8b20c4e116aaef77da5b5d5bbc9187e1d7943723fe8c9e5f77d978c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bc411bf8b20c4e116aaef77da5b5d5bbc9187e1d7943723fe8c9e5f77d978c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc4929a60aec828fd6d392644be10f80125b0294d6fd9ebe9b46400e1c667caa"
    sha256 cellar: :any_skip_relocation, ventura:        "cc4929a60aec828fd6d392644be10f80125b0294d6fd9ebe9b46400e1c667caa"
    sha256 cellar: :any_skip_relocation, monterey:       "cc4929a60aec828fd6d392644be10f80125b0294d6fd9ebe9b46400e1c667caa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c894c2ffaaedbc8f0f21bb272500cac300bea705ce1a09d3a9b96e760e05972e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match "error: Expression of type \"int\" is incompatible with return type \"str\"", output
  end
end
