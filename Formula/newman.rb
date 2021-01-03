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
    sha256 "564ac0ed7eb9da953f707fddc3d9d79ab1a39922f343ce09992d82cacf7d7e3f" => :big_sur
    sha256 "d8930623c04c44b0b1f18103826914018e046355f87c16f03f4c039a0779e38c" => :arm64_big_sur
    sha256 "b2357bcee103b650137d97b39d393b1c7745762fe87ed49e8eaaf22ac9726ce8" => :catalina
    sha256 "42b862e8121ef26bd7c1d25aebfbfc380c24a5c7787f68aeaa8e24e0a40531c0" => :mojave
    sha256 "caf8168c44fea1b87a60f136f0b17f8a09eea9f080b9bb0c9c2092efdc2679cf" => :high_sierra
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
