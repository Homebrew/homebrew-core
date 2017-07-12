require "language/node"

class GenerateJsonSchema < Formula
  desc "Generate a JSON Schema from Sample JSON"
  homepage "https://github.com/Nijikokun/generate-schema"
  url "https://registry.npmjs.org/generate-schema/-/generate-schema-2.5.1.tgz"
  sha256 "be647d514e7de0f8adff6fecd6c3faf361fc4801123b9a8ad0eebdce52a64de3"
  head "https://github.com/Nijikokun/generate-schema.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "03b1f1808a16d56b00f0694203067d9a591b13bcde57b946f81d84dd6634caf1" => :sierra
    sha256 "9dede05dc78bedb801c0bc57e7a41552aef6f3239a975f5f0bfaa21e230d39a7" => :el_capitan
    sha256 "3e1003bf8da22e9fcafa9c937f86bb4011f251da59534322ea835d9d97d8ebaa" => :yosemite
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
