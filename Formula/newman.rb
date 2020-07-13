require "language/node"

class Newman < Formula
  desc "Command-line collection runner for Postman"
  homepage "https://www.getpostman.com"
  url "https://registry.npmjs.org/newman/-/newman-5.1.2.tgz"
  sha256 "3138f0d5716e7d7dccb39b800e1d88f6ea36cf4dda72adbccf133ba6bea5066d"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b80e304708dd3d1b68cd402779a62953941b646d5e990ccbfcbd28c8e0e8ae3d" => :catalina
    sha256 "51e3c6a2cb29d72931820f1a1e52f7c4470ef71c893d3fcb5f792c2dfebf54ed" => :mojave
    sha256 "a714b5c7d88a374272ebd88e261ed4bb842ae9ba94c61074a6a65a87140ce48b" => :high_sierra
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
