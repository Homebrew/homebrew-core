require "language/node"

class Json5 < Formula
  desc "JSON enhanced with usability features"
  homepage "https://json5.org/"
  url "https://github.com/json5/json5/archive/v2.2.1.tar.gz"
  sha256 "2ad1be22d6138825a712411fac53086a8710b7d987e9aa81c59ee370b5a57030"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "38b3d5fd1167020fbb15e2778ce5614fbcd1417cd8d4fb0131de2fdacdb49582"
    sha256 cellar: :any_skip_relocation, big_sur:       "fed591c879ba5765efe81a0faf4c4cbd44e9c41b984307d0b72317933c0dadb5"
    sha256 cellar: :any_skip_relocation, catalina:      "09e87f239bbc187dba2e2fe5f865f078a7210827983835a625524d3d800dcf18"
    sha256 cellar: :any_skip_relocation, mojave:        "e2dc5ac648d7c114a8f6945ed986db3b88be6383afefe2f54c87a1d8deace6be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95bb5b8cf876c6ea17b8f2ad04a1070a8700c8ff5d047e85f106d1938459c313"
    sha256 cellar: :any_skip_relocation, all:           "95bb5b8cf876c6ea17b8f2ad04a1070a8700c8ff5d047e85f106d1938459c313"
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
