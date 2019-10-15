require "language/node"

class GenerateJsonSchema < Formula
  desc "Generate a JSON Schema from Sample JSON"
  homepage "https://github.com/Nijikokun/generate-schema"
  url "https://registry.npmjs.org/generate-schema/-/generate-schema-2.6.0.tgz"
  sha256 "1ddbf91aab2d649108308d1de7af782d9270a086919edb706f48d0216d51374a"
  head "https://github.com/Nijikokun/generate-schema.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d5a50f712bb6714564574d20cbd771e62ad1da6dcd58d9b7225822af0821d73" => :catalina
    sha256 "e049d098796be43aa340eca884fa71ec90f4fbeda02031142f66752df005de97" => :mojave
    sha256 "3461301c038b8bb6e15b8e183661976e95ea7b7e0659d57f0f21ea2c0eb4e67c" => :high_sierra
    sha256 "a6ff075810774d44030a59a12032d302c64834d03c7aabeb32efb8dc86d276de" => :sierra
    sha256 "5a5b34d8e233d9b75648c39f8edada5077c8f6c6466bd3358f3f661062ccbe83" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.json").write <<~EOS
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
    assert_match "schema.org", shell_output("#{bin}/generate-schema test.json", 1)
  end
end
