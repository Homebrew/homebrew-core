require "language/node"

class GenerateJsonSchema < Formula
  desc "Generate a JSON Schema from Sample JSON"
  homepage "https://github.com/Nijikokun/generate-schema"
  url "https://registry.npmjs.org/generate-schema/-/generate-schema-2.6.0.tgz"
  sha256 "1ddbf91aab2d649108308d1de7af782d9270a086919edb706f48d0216d51374a"
  head "https://github.com/Nijikokun/generate-schema.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7ae5fb43279c604ac2154cf0759220d558c27b0b96c1b3195dffd60701cd5d0" => :high_sierra
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
    input = <<~EOS
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
