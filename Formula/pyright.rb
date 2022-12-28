require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.286.tgz"
  sha256 "4c517ac9ba35418bf0baf65a29815a372b4c0a5f68a282b95afbd5ec1a784527"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6132659a72e04d62a29c869435dc0de99fb4c54584dd3979a29b5e3c91599536"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6132659a72e04d62a29c869435dc0de99fb4c54584dd3979a29b5e3c91599536"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6132659a72e04d62a29c869435dc0de99fb4c54584dd3979a29b5e3c91599536"
    sha256 cellar: :any_skip_relocation, ventura:        "c71d8bf53456c3b6eeba1b610270538d120a022dd7ccc444286a6c902771dbe4"
    sha256 cellar: :any_skip_relocation, monterey:       "c71d8bf53456c3b6eeba1b610270538d120a022dd7ccc444286a6c902771dbe4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c71d8bf53456c3b6eeba1b610270538d120a022dd7ccc444286a6c902771dbe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6132659a72e04d62a29c869435dc0de99fb4c54584dd3979a29b5e3c91599536"
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
    assert_match 'error: Expression of type "int" cannot be assigned to return type "str"', output
  end
end
