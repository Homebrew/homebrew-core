require "language/node"

class Newman < Formula
  desc "Command-line collection runner for Postman"
  homepage "https://www.getpostman.com"
  url "https://registry.npmjs.org/newman/-/newman-5.1.0.tgz"
  sha256 "8d528fcce3cee4ede6542396d8c6b24ee1cb822126aece19e883a342c1822d1d"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a00bb88049b63eda5e1f41ad578e28b4a2212984f66a7d441f46c42faf784937" => :catalina
    sha256 "3bf2bc9c5ddc05b427edfe9c2656fc75634adf46ea987ae143285609708637ed" => :mojave
    sha256 "48e6e2e69ddd036c090709610a7735dbb13ac96a12b750ccbb6f2195aa5bc531" => :high_sierra
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

    assert_match /newman/, shell_output("#{bin}/newman run #{path}")
    assert_equal version.to_s, shell_output("#{bin}/newman --version").strip
  end
end
