class Json5 < Formula
  desc "JSON enhanced with usability features"
  homepage "https://json5.org/"
  url "https://github.com/json5/json5/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "a98d1dd7c6b101fd99ae692102dc05a65f072b3e6f8077d3658819440bf76637"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "534d5ae84344ae22db82db67bb5df3f7dcab72e007a806f7b2f58b79790c4038"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "534d5ae84344ae22db82db67bb5df3f7dcab72e007a806f7b2f58b79790c4038"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "534d5ae84344ae22db82db67bb5df3f7dcab72e007a806f7b2f58b79790c4038"
    sha256 cellar: :any_skip_relocation, sonoma:         "534d5ae84344ae22db82db67bb5df3f7dcab72e007a806f7b2f58b79790c4038"
    sha256 cellar: :any_skip_relocation, ventura:        "534d5ae84344ae22db82db67bb5df3f7dcab72e007a806f7b2f58b79790c4038"
    sha256 cellar: :any_skip_relocation, monterey:       "534d5ae84344ae22db82db67bb5df3f7dcab72e007a806f7b2f58b79790c4038"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9b146e913a2062ed76d2e6f4cdfa8ad70c3605dda61a1b629f1189b1cb914ed"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
