require "language/node"

class GenerateJsonSchema < Formula
  desc "Generate a JSON Schema from Sample JSON"
  homepage "https://github.com/Nijikokun/generate-schema"
  url "https://registry.npmjs.org/generate-schema/-/generate-schema-2.3.1.tgz"
  sha256 "c73926a44ebdf7f732f531624c012d667479b949378148607527fecb36044254"
  head "https://github.com/Nijikokun/generate-schema.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "626e7f140070e16e7d4060f85aa98710bf9e268df7bbfe60f9feccec4f57c86f" => :sierra
    sha256 "99114f2be49f8d02725144ba168f38521deb75c9d8ce71344a4edc040a39aa56" => :el_capitan
    sha256 "5cc8964c154963ea8f4859b562ea735024644bee0552af6b457fbff40ffa3917" => :yosemite
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
