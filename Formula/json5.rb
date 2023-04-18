require "language/node"

class Json5 < Formula
  desc "JSON enhanced with usability features"
  homepage "https://json5.org/"
  url "https://github.com/json5/json5/archive/v2.2.3.tar.gz"
  sha256 "a98d1dd7c6b101fd99ae692102dc05a65f072b3e6f8077d3658819440bf76637"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e56197088965d111aad8994191dfe4a8f180581f0c1ba66fb2b2fbf894ccf4ac"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # Example taken from the official README
    (testpath/"test.json5").write <<~EOF
      {
        // comments
        unquoted: 'and you can quote me on that',
        singleQuotes: 'I can use "double quotes" here',
        lineBreaks: "Look, Mom! \
      No \\n's!",
        hexadecimal: 0xdecaf,
        leadingDecimalPoint: .8675309, andTrailing: 8675309.,
        positiveSign: +1,
        trailingComma: 'in objects', andIn: ['arrays',],
        "backwardsCompatible": "with JSON",
      }
    EOF
    system bin/"json5", "--validate", "test.json5"
  end
end
