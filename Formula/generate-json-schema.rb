require "language/node"

class GenerateJsonSchema < Formula
  desc "Generate a JSON Schema from Sample JSON"
  homepage "https://github.com/Nijikokun/generate-schema"
  url "https://registry.npmjs.org/generate-schema/-/generate-schema-2.3.1.tgz"
  sha256 "c73926a44ebdf7f732f531624c012d667479b949378148607527fecb36044254"
  head "https://github.com/Nijikokun/generate-schema.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0915c902a8de34bfe2298d4f91040eea18762c0e3e68747ce6e32a07e135810c" => :sierra
    sha256 "d573136e4025aa6ecdad3ca73bfc53307ef6ab212bd8307387a7ff9763db14ed" => :el_capitan
    sha256 "ac72c27b5ae36a0c40ba48b21d590519175395bd903ca7a3c46e4af840daa449" => :yosemite
    sha256 "8fc1b18f001ea586ce7f3e5d5c021ad76be4cb8010688a783a1c80b22e3e3167" => :mavericks
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    input = <<-EOS.undent
      {
          "id": 2,
          "name": "An ice sculpture",
          "price": 12.50,
          "tags": ["cold", "ice"],
          "dimensions": {
              "length": 7.0,
              "width": 12.0,
              "height": 9.5
          },
          "warehouseLocation": {
              "latitude": -78.75,
              "longitude": 20.4
          }
      }
    EOS
    assert_match "schema.org", pipe_output("#{bin}/generate-schema", input, 0)
  end
end
