require "language/node"

class GenerateJsonSchema < Formula
  desc "Generate a JSON Schema from Sample JSON"
  homepage "https://github.com/Nijikokun/generate-schema"
  url "https://registry.npmjs.org/generate-schema/-/generate-schema-2.4.0.tgz"
  sha256 "42502872e1e1b187ef7ace1964b38f47e3a20d7c880b8548694b57ee526ea910"
  head "https://github.com/Nijikokun/generate-schema.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8a5eb99bfc147426ff33fee438d7f3c88cac0bd0328dc7f65f2e9c18d23c15f" => :sierra
    sha256 "15693bf27610a0069e5073ee2fef2d980ecd86820cef16505e6b5eda26ec21b7" => :el_capitan
    sha256 "72eddfed43eb6a237737421af480835d63c88ff7f661d8d7e998e08eded75670" => :yosemite
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
