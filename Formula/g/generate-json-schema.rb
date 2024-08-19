class GenerateJsonSchema < Formula
  desc "Generate a JSON Schema from Sample JSON"
  homepage "https://github.com/Nijikokun/generate-schema"
  url "https://registry.npmjs.org/generate-schema/-/generate-schema-2.6.0.tgz"
  sha256 "1ddbf91aab2d649108308d1de7af782d9270a086919edb706f48d0216d51374a"
  license "MIT"
  head "https://github.com/Nijikokun/generate-schema.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cef6ca97403e624d9f0b6beb575964bb56b0ec382215c6b81442e4aa446e61ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cef6ca97403e624d9f0b6beb575964bb56b0ec382215c6b81442e4aa446e61ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cef6ca97403e624d9f0b6beb575964bb56b0ec382215c6b81442e4aa446e61ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "cef6ca97403e624d9f0b6beb575964bb56b0ec382215c6b81442e4aa446e61ac"
    sha256 cellar: :any_skip_relocation, ventura:        "cef6ca97403e624d9f0b6beb575964bb56b0ec382215c6b81442e4aa446e61ac"
    sha256 cellar: :any_skip_relocation, monterey:       "cef6ca97403e624d9f0b6beb575964bb56b0ec382215c6b81442e4aa446e61ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30f419aaa80a5d9c5387c22ec3803abe4d3e9b3ddaac9ccfbd4f044c70a89422"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
