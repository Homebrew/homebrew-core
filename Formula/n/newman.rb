require "language/node"

class Newman < Formula
  desc "Command-line collection runner for Postman"
  homepage "https://www.getpostman.com"
  url "https://registry.npmjs.org/newman/-/newman-6.1.2.tgz"
  sha256 "364b9e73156c18ceb1884327d38bb5b3192ef9291712a604496ffca738744d00"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "275eea0935b3d2303ac6048ce9f67dc7f095e109bcf0c577a3cc5d252fbd4890"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "275eea0935b3d2303ac6048ce9f67dc7f095e109bcf0c577a3cc5d252fbd4890"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "275eea0935b3d2303ac6048ce9f67dc7f095e109bcf0c577a3cc5d252fbd4890"
    sha256 cellar: :any_skip_relocation, sonoma:         "2817c91ed5a94aa549555d299bed2f73eed6cc20079188248b77e08613b03ce4"
    sha256 cellar: :any_skip_relocation, ventura:        "2817c91ed5a94aa549555d299bed2f73eed6cc20079188248b77e08613b03ce4"
    sha256 cellar: :any_skip_relocation, monterey:       "2817c91ed5a94aa549555d299bed2f73eed6cc20079188248b77e08613b03ce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "275eea0935b3d2303ac6048ce9f67dc7f095e109bcf0c577a3cc5d252fbd4890"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    path = testpath/"test-collection.json"
    path.write <<~EOS
      {
        "info": {
          "_postman_id": "db95eac2-6e1c-48c0-8c3a-f83c5341d4dd",
          "name": "Homebrew",
          "description": "Homebrew formula test",
          "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
        },
        "item": [
          {
            "name": "httpbin-get",
            "request": {
              "method": "GET",
              "header": [],
              "body": {
                "mode": "raw",
                "raw": ""
              },
              "url": {
                "raw": "https://httpbin.org/get",
                "protocol": "https",
                "host": [
                  "httpbin",
                  "org"
                ],
                "path": [
                  "get"
                ]
              }
            },
            "response": []
          }
        ]
      }
    EOS

    assert_match "newman", shell_output("#{bin}/newman run #{path}")
    assert_equal version.to_s, shell_output("#{bin}/newman --version").strip
  end
end
