require "language/node"

class GenerateJsonSchema < Formula
  desc "Generate a JSON Schema from Sample JSON"
  homepage "https://github.com/Nijikokun/generate-schema"
  url "https://registry.npmjs.org/generate-schema/-/generate-schema-2.5.0.tgz"
  sha256 "425b967a25b33ccb25de6902480775d77e55e53938412372d25a3803904345b0"
  head "https://github.com/Nijikokun/generate-schema.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7b79739ee484e0dfa98f7b3a919a88e53e9f4e0c1ede2a2f86eaaebf2cbf448" => :sierra
    sha256 "ee0106900573d7a915306fef61100e51cc321875dbd72c8cd468cca007a4a5f8" => :el_capitan
    sha256 "a036725b4086b6f7b2afd96fe4663a15416d29722558d98a00a6757bf4af822e" => :yosemite
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
