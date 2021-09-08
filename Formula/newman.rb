require "language/node"

class Newman < Formula
  desc "Command-line collection runner for Postman"
  homepage "https://www.getpostman.com"
  url "https://registry.npmjs.org/newman/-/newman-5.3.0.tgz"
  sha256 "ea4bba024f2c67a18c26db376d25d07039f782a591f333f85774c33df992f378"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "21130a928c057859222d1902adfa6429daa2e34a596505bbbd304284257f6d54"
    sha256 cellar: :any_skip_relocation, big_sur:       "ed2748b227245376f268f0d0b560fefe96b560e284acf5976068e900abfddcb6"
    sha256 cellar: :any_skip_relocation, catalina:      "ed2748b227245376f268f0d0b560fefe96b560e284acf5976068e900abfddcb6"
    sha256 cellar: :any_skip_relocation, mojave:        "ed2748b227245376f268f0d0b560fefe96b560e284acf5976068e900abfddcb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d64accb250a0fee5ebc201230b1a7ffff0f8f4a5c457c614e26211f96d8cb8a"
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
