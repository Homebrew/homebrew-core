require "language/node"

class GenerateJsonSchema < Formula
  desc "Generate a JSON Schema from Sample JSON"
  homepage "https://github.com/Nijikokun/generate-schema"
  url "https://registry.npmjs.org/generate-schema/-/generate-schema-2.4.0.tgz"
  sha256 "42502872e1e1b187ef7ace1964b38f47e3a20d7c880b8548694b57ee526ea910"
  head "https://github.com/Nijikokun/generate-schema.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "34a7493939dc9f4f64da7a2097185aef4c36637a7b2bc1d09054ec753b557bfd" => :sierra
    sha256 "2f13174bffd9ac0b72e4db1d2c904f7eff8a7612b066f1066e5d4329ffe58ae2" => :el_capitan
    sha256 "1d16c27d7181559996291f13da64cdc2e03f47c3c8bc9143f6406ee8d5632b4f" => :yosemite
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
