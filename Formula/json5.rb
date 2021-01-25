require "language/node"
class Json5 < Formula
  desc "JSON enhanced with usability features"
  homepage "https://json5.org/"
  url "https://github.com/json5/json5/archive/v2.1.3.tar.gz"
  sha256 "8377e5b7a604ba3e3113ec14f2346e89850224670c1593a542863ca1ea75c97d"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "23ab51ca388f7efb2bf410f059acc51c161ec45a5976fb5f4e483d1a19146a18" => :big_sur
    sha256 "09115626c7ab7470d31c81236b24ac1f23e7a4e81904355966638fced59d50e2" => :arm64_big_sur
    sha256 "bedfd496f81978deb0f7745b1465666460beb8f32b4b5cd2c304272177f4974e" => :catalina
    sha256 "568c1550671b000a316cfec4168c135039edb2dc714be89f9ac4282170fdd195" => :mojave
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
