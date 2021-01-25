require "language/node"

class Newman < Formula
  desc "Command-line collection runner for Postman"
  homepage "https://www.getpostman.com"
  url "https://registry.npmjs.org/newman/-/newman-5.2.2.tgz"
  sha256 "bac53129a0a71134c8a2ad08c66f9a7c38bf519fdfa99d101a252dcafde20f06"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c3926c935976ad87374883be61ba75351848437246709b58df1420a5fbb21bc9" => :big_sur
    sha256 "a729a0eb82cbf54d5d2cd1d65faaafbf71ec0593d8dbc75820273ab00c790191" => :arm64_big_sur
    sha256 "570353b988611888031ad036d657d5a36fefd9599c27d83c12bbd46b6f4c2fc3" => :catalina
    sha256 "dad7553e93780b1b20820f18302c1a94215529e1eabb1ed753f24c18a57987e1" => :mojave
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
