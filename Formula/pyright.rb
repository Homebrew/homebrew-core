require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.297.tgz"
  sha256 "a9947a8cefd2200d210fa6b06988faea6ee03771f66326a4657f4e47b7f3eca8"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55323de053b685cb5b7321c769f07db0f171cf8791a41f60f4c2caf8093faf5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55323de053b685cb5b7321c769f07db0f171cf8791a41f60f4c2caf8093faf5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55323de053b685cb5b7321c769f07db0f171cf8791a41f60f4c2caf8093faf5d"
    sha256 cellar: :any_skip_relocation, ventura:        "cbbd8965c21b628a565286800ca7789a47a51f45fe7eeab889bda47ca7e12e4f"
    sha256 cellar: :any_skip_relocation, monterey:       "cbbd8965c21b628a565286800ca7789a47a51f45fe7eeab889bda47ca7e12e4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbbd8965c21b628a565286800ca7789a47a51f45fe7eeab889bda47ca7e12e4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55323de053b685cb5b7321c769f07db0f171cf8791a41f60f4c2caf8093faf5d"
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
