require "language/node"

class GenerateJsonSchema < Formula
  desc "Generate a JSON Schema from Sample JSON"
  homepage "https://github.com/Nijikokun/generate-schema"
  url "https://registry.npmjs.org/generate-schema/-/generate-schema-2.6.0.tgz"
  sha256 "1ddbf91aab2d649108308d1de7af782d9270a086919edb706f48d0216d51374a"
  license "MIT"
  head "https://github.com/Nijikokun/generate-schema.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d19c2a0542dea7690c93f7a8e97a25c8979c7e489dca485dcfc35f6073d47beb"
    sha256 cellar: :any_skip_relocation, big_sur:       "aee39ac19fd8f45785021bd737daf8f8ab15e7265b5e196485259d5a2c2cfede"
    sha256 cellar: :any_skip_relocation, catalina:      "4d5a50f712bb6714564574d20cbd771e62ad1da6dcd58d9b7225822af0821d73"
    sha256 cellar: :any_skip_relocation, mojave:        "e049d098796be43aa340eca884fa71ec90f4fbeda02031142f66752df005de97"
    sha256 cellar: :any_skip_relocation, high_sierra:   "3461301c038b8bb6e15b8e183661976e95ea7b7e0659d57f0f21ea2c0eb4e67c"
    sha256 cellar: :any_skip_relocation, sierra:        "a6ff075810774d44030a59a12032d302c64834d03c7aabeb32efb8dc86d276de"
    sha256 cellar: :any_skip_relocation, el_capitan:    "5a5b34d8e233d9b75648c39f8edada5077c8f6c6466bd3358f3f661062ccbe83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12487b77022ffd791d6fbd7a50362a08f5209ba50ad1cc67c3558d63db1e9264"
    sha256 cellar: :any_skip_relocation, all:           "12487b77022ffd791d6fbd7a50362a08f5209ba50ad1cc67c3558d63db1e9264"
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
