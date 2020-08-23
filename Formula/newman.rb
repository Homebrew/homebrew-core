require "language/node"

class Newman < Formula
  desc "Command-line collection runner for Postman"
  homepage "https://www.getpostman.com"
  url "https://registry.npmjs.org/newman/-/newman-5.1.2.tgz"
  sha256 "3138f0d5716e7d7dccb39b800e1d88f6ea36cf4dda72adbccf133ba6bea5066d"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7dbf99b62e25a9ba6dc779120479340d4ed92892d0543148e513c1458b2cfa61" => :catalina
    sha256 "6138949598a71507c24a200cec0a4c6892efd4148b99a60836025166d50fcd8b" => :mojave
    sha256 "bd039293615be7652c6fe012571775ba6482721e71df5388de07035fe0764343" => :high_sierra
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
